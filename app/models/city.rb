class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  
  # def city_openings(*date_span)
  #   listings.reservations.where(checkin: date_span.first..date_span.last)
  # end
  
  # def self.highest_ratio_res_to_listings
  #   City.where(reservations)
  #   # City.where(:total_reservations / city.listings.size)
  #   City.minimum(:total_reservations)
  # end
  
  def self.most_res
    cities_reservations = {}

    City.all.collect do |city|
      cities_reservations[city] = city.listings.collect{|listing| listing.reservations.size}.reduce(0, :+)
    end
    
    cities_reservations.max_by{|k,v| v}.first
  end
  
  # def total_reservations
  #   listings.collect{|l| l.reservations.size}.reduce(0, :+)
  # end
end

