class ItemsController < ApplicationController
  def index
    if params[:collection].nil?
      @items = Item.limit(20)
    else
      @items = Item.limit(20).where(owning_collection: params[:collection])
    end

    render json: @items
  end
end