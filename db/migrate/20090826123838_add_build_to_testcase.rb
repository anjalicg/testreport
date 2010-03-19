class AddBuildToTestcase < ActiveRecord::Migration
  def self.up
    add_column :testcases, :build_id, :integer
  end

  def self.down
  end
end
