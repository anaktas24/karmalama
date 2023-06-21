class ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :apply]
  before_action :authorize_admin, except: [:index, :show, :apply]

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

  def new
    @listing = Listing.new
    authorize @listing
  end

  def create
    @listing = Listing.new(listing_params)
    @listing.user = current_user
    authorize @listing
    if @listing.save
      redirect_to listings_path
    else
      render :new, status: :unprocessable_entity
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

    respond_to do |format|
      if @listing.destroy
        format.html { redirect_to listings_path, notice: "Listing was successfully deleted." }
        format.json { head :no_content }
      else
        format.html { redirect_to listing_path, status: :unprocessable_entity, notice: "Listing could not be deleted." }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  def apply
    @listing = Listing.find(params[:id])
    authorize @listing
    @booking = Booking.new
    redirect_to @listing, notice: 'Application submitted successfully.'
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(:name, :description, :price_per_hour, :location, :photo, :category_type, :date)
  end

  def authorize_admin
    unless current_user.admin?
      flash[:error] = "You are not authorized to perform this action."
      redirect_to listings_path
    end
  end
end
