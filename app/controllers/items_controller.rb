class ItemsController < ApplicationController
  def index
    @options = self.options(params)

    @items = Item.distinct.joins(:field_types)

    @items = @items.where("metadatavalue.text_value like :metadata_value", {metadata_value: "%#{params[:value]}%"}) if params[:value].present?
    @items = @items.where("metadatafieldregistry.element = :element", {element: params[:element]}) if params[:element].present?
    @items = @items.where("metadatafieldregistry.qualifier = :qualifier", {qualifier: params[:qualifier]}) if params[:qualifier].present?
    @items = @items.where("metadataschemaregistry.short_id = :namespace", {namespace: params[:namespace]}) if params[:namespace].present?

    @items = @items.where(owning_collection: params[:collection]) if params[:collection].present?

    render json: @items.limit(@options[:limit]).offset((@options[:page]-1)*@options[:limit]).order(@options[:order])
  end


  def options(params)
    {
        page: params[:page] ? params[:page].to_i : Rails.configuration.x.PAGE,
        limit: params[:limit] ? self.least(params[:limit].to_i, Rails.configuration.x.LIMIT) : Rails.configuration.x.LIMIT,
        order: params[:order] ? params[:sort] : Rails.configuration.x.ORDER
    }
  end

  def least(first, second)
    first > second ? second : first
  end
end