class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      log_in user
      flash[:success] = t ".message_success"
      redirect_to user
    else
      flash.now[:danger] = t ".message_error"
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = t ".message_logout"
    redirect_to root_path
  end
end
