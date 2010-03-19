class CreateTestcases < ActiveRecord::Migration
  def self.up
    create_table :testcases do |t|
      t.column :testcase_id, :string
      t.column :testdescription, :string
      t.column :serial, :integer
    end
  end

  def self.down
    drop_table :testcases
  end
end
