class ProgressBarController < ApplicationController

  def show
    @progress_bar = ProgressBar.find(params[:id])
    render json: @progress_bar
  end

end