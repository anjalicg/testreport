class CreateTestplans < ActiveRecord::Migration
  def self.up
    create_table :testplans do |t|
      t.column :testcase_id, :string
      t.column :description,:string
      t.column :included, :string
      t.column :build_id, :integer
      t.column :reported_by, :string
      t.column :created_by, :datetime
    end
  end

  def self.down
    drop_table :testplans
  end
end
