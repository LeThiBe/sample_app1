class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      log_in user
      flash[:success] = t ".message_success"
      check_remember user
      redirect_back_or user
    else
      flash.now[:danger] = t ".message_error"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = t ".message_logout"
    redirect_to root_path
  end

  def check_remember user
    if params[:session][:remember_me] == Settings.sessions.value_remember
      remember user
    else
      forget user
    end
  end
end
