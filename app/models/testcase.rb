class Testcase < ActiveRecord::Base
  has_many :testreports
  belongs_to :release
  belongs_to :build
end
