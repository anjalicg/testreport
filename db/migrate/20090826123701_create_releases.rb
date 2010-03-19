class CreateReleases < ActiveRecord::Migration
  def self.up
    create_table :releases do |t|
      t.column :serial, :string
      t.column :created_at, :datetime
      t.column :start_date, :date
    end
  end

  def self.down
    drop_table :releases
  end
end
