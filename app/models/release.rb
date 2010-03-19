class Release < ActiveRecord::Base
  has_many :testcases
  has_many :testreports
  validates_uniqueness_of :serial
end
