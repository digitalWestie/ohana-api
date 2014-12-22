class Admin::CategoriesController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'

  def index
  end

  def edit
    @category = Category.find(params[:id])
    @categories = Category.where.not(id: params[:id]).pluck(:name, :id)
  end

  def update
    @category = Category.find(params[:id])
    respond_to do |format|
      params[:category][:ancestry] = nil if params[:category][:ancestry].eql?("")
      if @category.update(params[:category])
        format.html do
          redirect_to admin_categories_path, notice: 'Category was successfully updated.'
        end
      else
        format.html { render :edit }
      end
    end
  end

end
