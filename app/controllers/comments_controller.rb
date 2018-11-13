class CommentsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :comment_author_or_post_author, only: [:destroy]

    def new
        @comment = Comment.new
    end

    def create
        @comment = Comment.new
        @comment.assign_attributes({:text => params['text'], :post_id => params['post_id'], :user_id => current_user.id})
        if @comment.save!
            flash[:success] = "Comment posted!"
            comment = Comment.find(@comment.id)

            post_author = comment.micropost.user
            comment_author = comment.user
            #if post_author.id != comment_author.id
            UserMailer.notify_message(post_author, comment_author).deliver_now
            #end
            redirect_to request.referrer || root_url
        else
            flash[:danger] = "Impossible to comment!"
            redirect_to request.referrer || root_url 
        end
    end

    def destroy
        Comment.find(params[:id]).destroy
        flash[:success] = "Comment deleted"
        redirect_to request.referrer || root_url 
    end

    private
        def comment_author_or_post_author
            comment = Comment.find(params[:id])
            post_author = comment.micropost.user_id
            comment_author = comment.user_id
            
            if current_user.id != post_author || current_user.id != comment_author
                flash[:danger] = "Impossible to destroy!"
                redirect_to request.referrer || root_url 
            end

        end

end
