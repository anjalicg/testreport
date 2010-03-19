class CreateTestreports < ActiveRecord::Migration
  def self.up
    create_table :testreports do |t|
      t.column :testcase_id, :string
      t.column :release_id, :integer
      t.column :executed_by, :string
      t.column :result, :string
      t.column :observation, :string
      t.column :deviations, :string
      t.column :build_id, :integer
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :testreports
  end
end
