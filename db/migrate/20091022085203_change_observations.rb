class ChangeObservations < ActiveRecord::Migration
  def self.up
    change_column :testreports, :observation, :text
    change_column :testreports, :deviations, :text
  end

  def self.down
  end
end
