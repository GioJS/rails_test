class LocaleController < ApplicationController
    def setLocale
        session[:locale] = params[:locale]
    end
end
