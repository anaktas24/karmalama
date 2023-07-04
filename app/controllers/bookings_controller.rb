class BookingsController < ApplicationController
  before_action :find_booking, only: [:show, :accept, :reject, :pending, :completed]

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
    @booking = @listing.bookings.new(booking_params)
    @booking.user_id = current_user.id
    @booking.status = params[:commit] == 'Apply' ? 'Pending' : 'Accepted'

    if @booking.save
      redirect_to my_bookings_path, notice: 'Listing applied successfully.'
    else
      redirect_to my_bookings_path, alert: 'Failed to apply listing.'
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
        # @booking.status = "pending"
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
    puts "Booking ID: #{params[:id]}" # Output the value of params[:id] to the console
    logger.info("Booking ID: #{params[:id]}")
    if @booking.destroy
      puts "Booking destroyed successfully"
      respond_to do |format|
        format.html { redirect_to my_bookings_path, notice: "Booking was successfully cancelled." }
        format.json { head :no_content }
      end
    else
      puts "Failed to destroy booking"
      redirect_to my_bookings_path, status: :unprocessable_entity
    end
  end

  #Impact
  def complete_booking
    if @booking.status == 'completed'
      flash[:notice] = 'Booking already completed.'
    else
      @booking.update(status: 'completed')
      current_user.increment!(points: current_user.points + @booking.points)
      current_user.increment!(:hours_worked, @booking.hours)
      flash[:notice] = "Booking completed. You have been awarded #{@booking.points} points."

      current_user.update_level # Call the update_level method to update the user's level
    end

    redirect_to booking_path(@booking)
  end

  private

  def booking_params
    params.require(:booking).permit(:name, :description, :points, :location)
  end

  def find_booking
    @booking = Booking.find(params[:id])
  end
end
