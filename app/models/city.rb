class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  
  def city_openings(start_date, end_date)
    listings.reject do |listing|
      listing.reservations.any? do |reservation|
        (reservation.checkin <= end_date.to_date) && (reservation.checkout >= start_date.to_date)
      end
    end
  end
  
  def self.highest_ratio_res_to_listings
    City.where(reservations)
    # City.where(:total_reservations / city.listings.size)
    City.minimum(:total_reservations)
  end
  
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

