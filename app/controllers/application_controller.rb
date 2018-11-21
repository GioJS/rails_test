class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :set_locale



 
  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
  end

  private

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = t('plslog')
        redirect_to login_url
      end
    end
end
