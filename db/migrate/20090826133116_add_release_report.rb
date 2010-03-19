class AddReleaseReport < ActiveRecord::Migration
  def self.up
    remove_column :testreports, :release_id
    add_column :testreports, :release_id, :integer
  end

  def self.down
  end
end
