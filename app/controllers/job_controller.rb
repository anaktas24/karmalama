class JobController < ApplicationController
  def complete
    @user = current_user
    @job = Job.find(params[:job_id])
    points_awarded = calculate_points(@job.difficulty) # Implement your logic to calculate points based on job difficulty
    @user.jobs << @job
    @user.points += points_awarded
    @user.update_level
    # Redirect or render appropriate views
    redirect_to impact_path
  end

  private

  def calculate_points(difficulty)
    case difficulty.to_sym
    when :easy
      10 # Example: award 10 points for an easy job
    when :medium
      20 # Example: award 20 points for a medium job
    when :hard
      30 # Example: award 30 points for a hard job
    else
      0
    end
  end
end
