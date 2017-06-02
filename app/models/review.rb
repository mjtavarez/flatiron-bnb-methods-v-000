class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  
  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true
  
  validate :checked_out, :accepted
  
  
  private
    def checked_out
      if reservation && reservation.checkout > Date.today
        errors.add(:guest_id, "You cannot write a review until you have checked out")
      end
    end
    
    def accepted
      if reservation && reservation.status != "accepted"
        errors.add(:guest_id, "You must have a reservation to leave a review")
      end
    end
end
