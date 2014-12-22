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
    set_parent
    respond_to do |format|
      if @category.update(params[:category])
        format.html do
          redirect_to admin_categories_path, notice: 'Category was successfully updated.'
        end
      else
        format.html { render :edit }
      end
    end
  end

  def new
    @category = Category.new
    @categories = Category.pluck(:name, :id)
  end

  def create
    @category = Category.new(params[:category])
    set_parent
    respond_to do |format|
      if @category.save
        format.html do
          redirect_to admin_categories_path, notice: 'Category was successfully created.'
        end
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to admin_categories_path, notice: 'Category was removed.'
  end

  private

  def set_parent
    ancestry = params[:category].delete(:ancestry)
    if ancestry.eql?("")
      @category.parent = nil
    else
      @category.parent = Category.find_by(id: ancestry)
    end
  end

end
