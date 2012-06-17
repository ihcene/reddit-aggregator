['open-uri', 'rss'].map { |e| require e }

class RssController < ApplicationController
  def index
    @entries = Entry.order('comments desc').limit(200)
    if params[:range] && /\d+\.\.\d+/.match(params[:range])
      @entries = @entries.where(
        'comments' => Range.new(
          *params[:range].split("..").map{ |s| s.to_i }
        )
      )
    end
    
    if params[:date].present?
      @entries = @entries.where(
        'created_at > ?', (params[:date].to_i - 1).days.ago.midnight
      )
    end

    if params[:category].present?
      @entries = @entries.where :category => params[:category]
    end

    if params[:no].present?
      @entries = @entries.where 'category <> :category', :category => params[:no]
    end
  end
  
  def fetch
    surreddit = ['programming', 'ruby', 'rails', 'php', 'python', 'java', 'dotnet', 'aspnet', 'CSS', 'Microsoft', 'javascript', 'jQuery', 'HTML5', 'SEO', 'coding', 'browsers', 'web', 'webdesign']
    
    surreddit.each do |reddit|
      feed_content = open("http://www.reddit.com/r/#{reddit}/.rss") { |f| f.read }
      feed_parsed = RSS::Parser.parse(feed_content, false)

      feed_parsed.items.map do |item|
        /\[(\d+)/.match(item.description)
        nb = $1.to_i
        e = Entry.find_or_create_by_title_and_category(:title => item.title.slice(0..254), :category => reddit, :uri => item.link, :comments => nb)
      
        e.update_attributes(:comments => $1.to_i) if e.comments < nb
      end
    end
    
    redirect_to :controller => 'rss', :action => "index", :format => params[:format]
  end
end
