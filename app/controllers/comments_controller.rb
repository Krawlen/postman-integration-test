#
class CommentsController < ApplicationController
  def index
    @comments = Comment.all
    render_resource_or_error(@comments)
  end

  def create
    @comment = Comment.new(permitted_attributes)
    @comment.save
    render_resource_or_error(@comment, status: :created)
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update(permitted_attributes)
    render_resource_or_error(@comment)
  end

  def show
    @comment = Comment.find(params[:id])
    render_resource_or_error(@comment)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    head :no_content
  end

  private

  def render_resource_or_error(resource, status: :ok, include: nil)
    status ||= :ok
    if resource.is_a?(ActiveRecord::Relation) || resource.is_a?(Enumerable)
      render(json: resource, include: include, status: status, adapter: :json_api)
      # If the resource was unchanged, show it. If the resource was changed AND is valid, show it
    elsif !resource.valid?
      render_errors_from_resource(resource)
    else
      render(json: resource, include: include, status: status, adapter: :json_api)
    end
  end

  def render_errors_from_resource(record, status: :unprocessable_entity)
    render json: record, status: status, serializer: ActiveModel::Serializer::ErrorSerializer
  end

  def attributes
    params.require(:data).require(:attributes)
  end

  def relationships
    params.require(:data).fetch(:relationships, {})
  end

  def permitted_attributes
    attributes.permit(:content, :title)
  end
end
