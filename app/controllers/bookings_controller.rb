class BookingsController < ApplicationController
  before_action :find_booking, only: [:show, :confirm, :reject]

  def index
    @listing = Listing.find(params[:listing_id])
    @bookings = Booking.where(listing: @listing)
  end


  def my_bookings
    @bookings = current_user.bookings
  end

  def show
    authorize @booking
    @listing = @booking.listing
  end

  def create
    @listing = Listing.find(params[:listing_id])
    @booking = @listing.bookings.build(booking_params)
    @booking.user = current_user
    @booking.status = "pending"
    # authorize @booking

    if @booking.save
      redirect_to my_bookings_path, notice: 'Listing applied successfully.'
    else
      redirect_to listings_path, alert: 'Failed to apply listing.'
    end
  end



  def edit
    @booking = Booking.find(params[:id])
    @listing = @booking.listing
    authorize @booking
  end

  def update
    @booking = Booking.find(params[:id])
    authorize @booking

    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to my_bookings_path, notice: "Booking was updated and the request has been reissued to the listing owner." }
        format.json { render :show, status: :ok, location: @booking }
        @booking.status = "pending"
        @booking.save
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
        # need to check these errors works (no validations)
      end
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    # authorize @booking

    puts "Booking found: #{@booking}"

    if @booking.destroy
      puts "Booking successfully destroyed"
      respond_to do |format|
        format.html { redirect_to my_bookings_path, notice: "Booking was successfully cancelled." }
        format.json { head :no_content }
      end
    else
      puts "Failed to destroy booking"
      redirect_to my_bookings_path, status: :unprocessable_entity
    end
  end


  private

  def booking_params
    params.require(:booking).permit(:name, :description, :price_per_hour, :location)
  end

  def find_booking
    @booking = Booking.find(params[:id])
  end
end
