class ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :apply]
  before_action :authorize_admin, except: [:index, :show, :apply]
  def new
    @listing = Listing.new

  end

  def index
    @listings = policy_scope(Listing)
    if params[:query].present?
      sql_query = "name ILIKE :query OR location ILIKE :query"
      @listings = Listing.where(sql_query, query: "%#{params[:query]}%")
    else
      @listings = Listing.all
    end
    puts @listings.inspect
    render 'index'
  end

  def show
    @listing = Listing.find(params[:id])

    @booking = Booking.new
  end

  def create
    @listing = Listing.find(params[:listing_id])
    @booking = Booking.find_by(listing: @listing, user: current_user)

    if @booking
      # Booking already exists, so it's a cancel action
      if @booking.destroy
        redirect_to my_bookings_path, notice: 'Booking canceled successfully.'
      else
        redirect_to my_bookings_path, alert: 'Failed to cancel booking.'
      end
    else
      # Booking doesn't exist, so it's an apply or register action
      @booking = @listing.bookings.build
      @booking.user = current_user
      @booking.name = @listing.name
      @booking.description = @listing.description
      @booking.location = @listing.location

      if @booking.save
        redirect_to my_bookings_path, notice: 'Booking created successfully.'
      else
        redirect_to my_bookings_path, alert: 'Failed to create booking.'
      end
    end
  end

  def edit
    @listing = Listing.find(params[:id])

  end

  def update
    @listing = Listing.find(params[:id])


    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to my_bookings_path, notice: "Listing was successfully updated." }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @listing = Listing.find(params[:id])


    if @listing.destroy
      respond_to do |format|
        format.html { redirect_to my_bookings_path, notice: "Listing was successfully deleted." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to my_bookings_path, status: :unprocessable_entity, notice: "Listing could not be deleted." }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(:name, :description, :price_per_hour, :location, :photo, :category_type, :date)
  end
end
