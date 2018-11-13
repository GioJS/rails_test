class CommentsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]

    def new
        @comment = Comment.new
    end

    def create
        @comment = Comment.new
        @comment.assign_attributes({:text => params['text'], :post_id => params['post_id'], :user_id => current_user.id})
        if @comment.save!
            flash[:success] = "Comment posted!"
            redirect_to request.referrer || root_url
        else
            flash[:danger] = "Impossible to comment!"
            redirect_to request.referrer || root_url 
        end
    end



end
