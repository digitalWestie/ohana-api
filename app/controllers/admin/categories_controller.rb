class Admin::CategoriesController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'

  def index
    #@categories = Category.all
  end
end
