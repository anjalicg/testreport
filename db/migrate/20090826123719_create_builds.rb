class CreateBuilds < ActiveRecord::Migration
  def self.up
    create_table :builds do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :builds
  end
end
