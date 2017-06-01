class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :available?, :checkin_before_checkout

  
  before_validation :is_not_host
  
  def duration
    (checkout - checkin).to_i
  end
  
  def total_price
    (listing.price)*duration
  end
  
  private
    def is_not_host
      Listing.find(self.listing_id).host_id != self.guest_id
    end
    
    def available?
      Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
        booked_dates = r.checkin..r.checkout
        if booked_dates.include?(checkin) || booked_dates.include?(checkout)
          errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
        end
      end
    end
    
    def checkin_before_checkout
      if checkout && checkin && checkout <= checkin
        errors.add(:guest_id, "You must checkout after you checkin")
      end
    end
  
end
