ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  fixtures :all
  include ApplicationHelper

  def is_logged_in?
    session[:user_id].present?
  end

  # Log in as a particular user.
  def log_in_as user
    session[:user_id] = user.id
  end

  def check_valid user
    patch password_reset_path(user.reset_token),
      params: {email: user.email,
               user: {password: "foobaz",
                      password_confirmation: "barquux"}}
    assert_select "div#error_explanation"
    patch password_reset_path(user.reset_token),
      params: {email: user.email,
               user: {password: "",
                      password_confirmation: ""}}
    assert_select "div#error_explanation"
    patch password_reset_path(user.reset_token),
      params: {email: user.email,
               user: {password: "foobaz",
                      password_confirmation: "foobaz"}}
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end

class ActionDispatch::IntegrationTest
  # Log in as a particular user.
  def log_in_as user, password: "123456", remember_me: "1"
    post login_path, params: {session: {email: user.email,
                                        password: password,
                                        remember_me: remember_me}}
  end
end
