class BidsController < ApplicationController

  before_action :authenticate_user

  def index
    @bids = Bid.all.order("auction_id ASC")
  end

  def create
    @auction = Auction.find(params[:auction_id])
    @bid   = @auction.bids.new bid_params
    if @bid.save
      redirect_to auction_path(@auction), notice: "Bid saved"
    else
      render "/auctions/show"
    end
  end

  private

  def bid_params
    params.require(:bid).permit(:amount)
  end

end
