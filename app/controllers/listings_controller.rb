class ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :apply]
  before_action :authorize_admin, except: [:index, :show, :apply]
  def new
    @listing = Listing.new
    authorize @listing
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
    authorize @listing
    @booking = Booking.new
  end


  def create
    @listing = Listing.find(params[:id])
    @booking = Booking.find_by(listing: @listing, user: current_user)

    if @booking
      # Booking already exists, so it's a cancel action
      if @booking.destroy
        redirect_to my_bookings_path, notice: 'Booking canceled successfully.'
      else
        redirect_to listings_path, alert: 'Failed to cancel booking.'
      end
    else
      # Booking doesn't exist, so it's an apply or register action
      @booking = @listing.bookings.build
      @booking.user = current_user
      @booking.name = @listing.name
      @booking.description = @listing.description
      @booking.location = @listing.location

      if params[:apply_type] == 'apply'
        @booking.status = 'pending'
      elsif params[:apply_type] == 'register'
        @booking.status = 'confirmed'
      else
        redirect_to listings_path, alert: 'Invalid application type.'
        return
      end

      if @booking.save
        if @booking.status == 'pending'
          redirect_to my_bookings_path(section: 'pending'), notice: 'Listing applied successfully. It is now pending confirmation.'
        else
          redirect_to my_bookings_path, notice: 'Listing applied successfully. Please complete your registration.'
        end
      else
        redirect_to listings_path, alert: 'Failed to apply listing.'
      end
    end
  end



  def edit
    @listing = Listing.find(params[:id])
    authorize @listing
  end

  def update
    @listing = Listing.find(params[:id])
    authorize @listing

    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to listings_path, notice: "Listing was successfully updated." }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @listing = Listing.find(params[:id])
    authorize @listing

    if @listing.destroy
      respond_to do |format|
        format.html { redirect_to listings_path, notice: "Listing was successfully deleted." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to listing_path, status: :unprocessable_entity, notice: "Listing could not be deleted." }
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

  # def authorize_admin
  #   unless current_user.admin?
  #     flash[:error] = "You are not authorized to perform this action."
  #     redirect_to listings_path
  #   end
  # end
end
