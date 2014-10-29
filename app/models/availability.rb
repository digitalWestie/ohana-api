class Availability < ActiveRecord::Base
  attr_accessible :hours
  belongs_to :service
  belongs_to :location
end
