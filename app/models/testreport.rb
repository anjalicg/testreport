class Testreport < ActiveRecord::Base
  belongs_to :testcase
  belongs_to :release
  belongs_to :build
  #validates_format_of :observation, :with => /\[.*\]:.*/, :on => :update, :message=>": Expected Format of Observation field is '[BugId]: Bug Description' "

end
