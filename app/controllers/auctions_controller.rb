class AuctionsController < ApplicationController

    before_action :authenticate_user, except: [:index, :show]

    before_action(:find_auction, {only: [:show ]})

  def index
    @auctions = Auction.all
  end

  def new
        @auction = Auction.new
  end

  def create
    @auction           = Auction.new(auction_params)
    @auction.user      = current_user
    if @auction.save
      redirect_to auctions_path, notice: "Auction created successfully"
    else
      render :new
    end
  end

  def show
    @auction = Auction.find params[:id]
    @bid = Bid.new
    #@auction_bids = @auction.bids.order(created_at: :DESC)
  end

  private

    def auction_params
      params.require(:auction).permit([:title, :details, :end_on, :reserve_price])
    end

    def find_auction
      @auction = Auction.find params[:id]
    end

end
