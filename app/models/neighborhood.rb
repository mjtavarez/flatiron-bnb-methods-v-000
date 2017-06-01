class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    listings.reject do |listing|
      listing.reservations.any? do |reservation|
        (reservation.checkin <= end_date.to_date) && (reservation.checkout >= start_date.to_date)
      end
    end
  end
  
  def self.highest_ratio_res_to_listings
    neighborhood_ratios = {}
    
    Neighborhood.all.each do |neighborhood|
      neighborhood_ratios[neighborhood.id] = (neighborhood.listings.collect{|listing| listing.reservations.size}.sum)
      (neighborhood_ratios[neighborhood.id]/neighborhood.listings.size.to_f) unless neighborhood.listings.empty?
    end
    
    Neighborhood.find(neighborhood_ratios.max_by{|neighborhood_id, ratio| ratio}[0])
  end
  
  def self.most_res
    res_by_nabe = {}
    Neighborhood.all.each do |neighborhood|
      res_by_nabe[neighborhood.id] = (neighborhood.listings.collect{|listing| listing.reservations.size}.sum)
    end
    
    Neighborhood.find(res_by_nabe.max_by{|nabe_id, reservations_count| reservations_count}[0])
  end

end
