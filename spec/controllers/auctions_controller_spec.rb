require 'rails_helper'

RSpec.describe AuctionsController, type: :controller do


  let(:user) { FactoryGirl.create(:user) }


  let(:auction)   { FactoryGirl.create(:auction, user: user) }

  let(:auction_1) { create(:auction) }

  describe "#new" do
    context "with user not signed in" do
      it "redirects to user sign in page" do
        get :new
        expect(response).to redirect_to(new_session_path)
      end
    end
    context "with user signed in" do
      before do
        # GIVEN
        u = FactoryGirl.create(:user)
        request.session[:user_id] = u.id

        # WHEN
        get :new
      end

      it "renders the new template" do
        # THEN
        expect(response).to render_template(:new)
      end

      it "create a new auction object assigned to `auction` instance variable" do
        # THEN
        expect(assigns(:auction)).to be_a_new(Auction)
      end
    end
  end

  describe "#create" do
    context "with no user signed in" do
      it "redirects to the sign in page" do
        post :create, {auction: {}} # params don't matter here becuase the
                                     # controller should redirect before making
                                     # use of the auction params
        expect(response).to redirect_to new_session_path
      end
    end

    context "With user signed in" do
      def valid_params
        FactoryGirl.attributes_for(:auction)
      end

      before do
        request.session[:user_id] = user.id
      end

      context "with valid parameters" do
        it "creates a auction record in the database" do
          before_count = Auction.count
          post :create, auction: valid_params
          after_count  = Auction.count
          expect(after_count - before_count).to eq(1)
        end

        it "associates the auction with the signed in user" do
          post :create, auction: valid_params
          expect(Auction.last.user).to eq(user)
        end

        it "redirects to auction show page" do
          post :create, auction: valid_params
          expect(response).to redirect_to(auction_path(Auction.last))
        end
      end
      context "with invalid parameters" do
        def request_with_invalid_title
          post :create, auction: valid_params.merge({title: nil})
        end

        it "doesn't create a auction record in the database" do
          before_count = Auction.count
          request_with_invalid_title
          after_count  = Auction.count
          expect(before_count).to eq(after_count)
        end

        it "renders the new template" do
          request_with_invalid_title
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe "#show" do
    it "renders the show template" do
      get :show, id: auction.id
      expect(response).to render_template(:show)
    end

    it "sets a auction instance variable with the passed id" do
      get :show, id: auction.id
      # there must be an instance variable named @auction
      expect(assigns(:auction)).to eq(auction)
    end
  end


  describe "#index" do

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "assigns an instance variable auctions with all the auctions" do
      # GIVEN: we have auctions created in the database
      auction
      auction_1
      # WHEN: Making the GET request to the INDEX action
      get :index
      # THEN: I have an instance variable @auctions that contain the two auctions
      expect(assigns[:auctions]).to eq([auction, auction_1])
    end

  end

end
