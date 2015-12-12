class User < ActiveRecord::Base

  has_secure_password

  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :auctions, dependent: :destroy

  has_many :bids, dependent: :nullify
  has_many :bided_auctions, through: :bids, source: :auction

  def full_name
    "#{first_name} #{last_name}"
  end

end
