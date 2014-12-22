class Admin::CategoriesController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'

  def index
    #@categories = Category.all
  end

  def edit
    @category = Category.find(params[:id])
  end
end
