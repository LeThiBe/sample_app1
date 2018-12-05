class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      check_active user
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

  def check_active user
    if user.activated?
      log_in user
      check_remember user
      redirect_back_or user
    else
      message = t ".message_not_active"
      flash[:warning] = message
      redirect_to root_url
    end
  end

  def check_remember user
    if params[:session][:remember_me] == Settings.sessions.value_remember
      remember user
    else
      forget user
    end
  end
end
