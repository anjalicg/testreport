class AddReleaseDoc < ActiveRecord::Migration
  def self.up
    add_column :releases, :doc, :string
  end

  def self.down
  end
end
