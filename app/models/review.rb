class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  
  validates :rating, :description, :reservation_id, presence: true
  validate :checked_out
  
  private
    def checked_out
      Reservation.find(reservation.id).checkout < Date.today
    end

end
