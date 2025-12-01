require 'set'

class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy, :like, :unlike]
  before_action :set_commentable, only: [:index, :create]
  before_action :set_comment, only: [:update, :destroy, :like, :unlike]
  before_action :set_user_liked_comment_ids, only: [:index]

  def index
    comments = @commentable.comments.includes(:user, replies: :user)
                           .by_locale(params[:locale] || 'en')
                           .root_comments
                           .ordered_by_path
    render json: format_comments(comments)
  end

  def create
    comment = @commentable.comments.build(comment_params)
    comment.user = current_user

    if comment.save
      render json: format_comment(comment), status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @comment.user_id == current_user.id || current_user.admin?
      if @comment.update(content: params[:content])
        render json: format_comment(@comment)
      else
        render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end

  def destroy
    if @comment.user_id == current_user.id || current_user.admin?
      @comment.destroy
      head :no_content
    else
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end

  def like
    like = @comment.likes.find_or_initialize_by(user: current_user)

    if like.persisted? || like.save
      render json: format_comment(@comment.reload)
    else
      render json: { errors: like.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def unlike
    like = @comment.likes.find_by(user: current_user)
    like&.destroy

    render json: format_comment(@comment.reload)
  end

  private

  def set_commentable
    commentable_type = params[:commentable_type]
    commentable_id = params[:commentable_id]

    @commentable = case commentable_type
    when 'BlogPost'
      BlogPost.find(commentable_id)
    when 'Project'
      Project.find(commentable_id)
    else
      raise ActiveRecord::RecordNotFound, "Invalid commentable type"
    end
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_user_liked_comment_ids
    return @user_liked_comment_ids = Set.new unless current_user

    locale = params[:locale] || 'en'
    comment_ids = Comment.where(commentable: @commentable, locale: locale).pluck(:id)
    @user_liked_comment_ids = CommentLike.where(user_id: current_user.id, comment_id: comment_ids).pluck(:comment_id).to_set
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id, :locale)
  end

  def format_comments(comments)
    comments.map { |comment| format_comment(comment) }
  end

  def format_comment(comment)
    {
      id: comment.id,
      content: comment.content,
      depth: comment.depth,
      path: comment.path,
      locale: comment.locale,
      user: {
        id: comment.user.id,
        name: comment.user.name,
        email: comment.user.email
      },
      likes_count: comment.likes_count,
      liked_by_current_user: liked_by_current_user?(comment),
      can_edit: can_modify_comment?(comment),
      can_delete: can_modify_comment?(comment),
      parent_id: comment.parent_id,
      replies: format_comments(comment.replies.ordered_by_path),
      created_at: comment.created_at,
      updated_at: comment.updated_at
    }
  end

  def liked_by_current_user?(comment)
    return false unless current_user

    return @user_liked_comment_ids.include?(comment.id) if defined?(@user_liked_comment_ids)

    comment.likes.exists?(user_id: current_user.id)
  end

  def can_modify_comment?(comment)
    return false unless current_user

    comment.user_id == current_user.id || current_user.admin?
  end
end
