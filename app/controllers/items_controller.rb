class ItemsController < ApplicationController
  def index
    @items = Item.limit(20)

    render json: @items
  end
end