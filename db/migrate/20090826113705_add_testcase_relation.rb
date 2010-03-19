class AddTestcaseRelation < ActiveRecord::Migration
  def self.up
    remove_column :testreports, :testcase_id
    add_column :testreports, :testcase_id, :integer
  end

  def self.down
  end
end
