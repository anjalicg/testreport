class AddTestDescription < ActiveRecord::Migration
  def self.up
    add_column :testcases, :steps,:string
    add_column :testcases, :output,:string
    add_column :testcases, :profile,:string
  end

  def self.down
  end
end
