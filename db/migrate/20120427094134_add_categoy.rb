class AddCategoy < ActiveRecord::Migration
  def self.up
    add_column :entries, :category, :string, :default => 'programming'
  end

  def self.down
    remove_column :entries, :category
  end
end
