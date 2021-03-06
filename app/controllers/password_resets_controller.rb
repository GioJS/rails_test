class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if isValidUser? 
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t("email_sent")
      redirect_to root_url
    else
      flash.now[:danger] = t('invalid_user')
      render 'new'
    end
  end

  def update
    if password_blank?
      flash.now[:danger] = t('password_b')
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = t('password_r')
      redirect_to @user
    else
      render 'edit'
    end
  end

  def edit
  end

  private

  def isValidUser?
    @user && @user.activated?
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def password_blank?
    params[:user][:password].blank?
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless (@user && @user.activated? &&
            @user.authenticated?(:reset, params[:id]))
      flash[:danger] = t('invalid_user')
      redirect_to root_url
    end
  end

   def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t('expired_pwd')
      redirect_to new_password_reset_url
    end
  end
end
