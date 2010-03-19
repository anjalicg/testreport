class Build < ActiveRecord::Base
  has_many :testcases
  has_many :reports
end
