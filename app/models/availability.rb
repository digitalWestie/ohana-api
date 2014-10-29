class Availability < ActiveRecord::Base
  attributes :hours
  belongs_to :service
  belongs_to :location
end
