class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = t('acc_not_act')
        message += t('check_email')
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = t('login_failed')
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
