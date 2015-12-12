class Auction < ActiveRecord::Base
  belongs_to :user

    has_many :bids, dependent: :nullify
    has_many :bided_users, through: :bids, source: :user

    validates :title, presence: true
    validates :reserve_price, presence: true, numericality: {greater_than: 10}

    #Add state machine with these states for the auction.: published / reserve met / won / canceled / reserve not met. Just enforce triggering going from published to reserve met for now.

    #Validate that bid price must by higher than the current price. Set current price to highest bid.

    include AASM

    aasm whiny_transitions: false do
      state :published, initial: true
      state :reserved
      state :unreserved

      event :reserve do
        transitions from: :published, to: :reserved
      end

    end

end
