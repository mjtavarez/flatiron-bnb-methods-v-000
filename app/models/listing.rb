class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :listing_type, :address, :title, :description, :price, :neighborhood_id, presence: true
  
  before_create :make_host
  after_destroy :update_host_status
  
  
  def average_review_rating
    all_res_ratings = reservations.collect{|reservation| reservation.review.rating}.sum
    all_res_ratings.to_f / reservations.size unless reservations.empty?
  end
  
  
  private
    def make_host
      User.find(self.host_id).update(:host => true)
    end
    
    def update_host_status
      if Listing.where(host_id: self.host_id).where(host_id: self.host_id).empty?
        User.find(self.host_id).update(host: false)
      end
    end
end
