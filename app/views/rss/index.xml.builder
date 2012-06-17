xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
 xml.channel do

   xml.title       "RSS ordre commentaires décroissant"
   xml.link        url_for :only_path => false, :controller => 'articles'
   xml.description "Developpez.net"

   @entries.each do |entry|
     xml.item do
       xml.title       entry.title
       xml.link        entry.uri
       xml.description "#{entry.comments} commentaire(s), last comment #{time_ago_in_words(entry.updated_at)} ago"
     end
   end

 end
end