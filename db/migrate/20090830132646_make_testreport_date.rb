class MakeTestreportDate < ActiveRecord::Migration
  def self.up
    remove_column :testreports, :updated_at
    add_column :testreports, :updated_at, :date
  end

  def self.down
  end
end
