class ChangeCreatedAt < ActiveRecord::Migration
  def self.up
    remove_column :testplans, :created_by
    add_column :testplans, :created_at, :datetime
  end

  def self.down
  end
end
