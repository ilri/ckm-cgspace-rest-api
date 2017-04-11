class ItemsController < ApplicationController
  def index
    @items = Item.distinct.limit(20).joins(:field_types)

    @items = @items.where("metadatavalue.text_value like :metadata_value", {metadata_value: "%#{params[:value]}%"}) if params[:value].present?
    @items = @items.where("metadatafieldregistry.element = :element", {element: params[:element]}) if params[:element].present?
    @items = @items.where("metadatafieldregistry.qualifier = :qualifier", {qualifier: params[:qualifier]}) if params[:qualifier].present?
    @items = @items.where("metadataschemaregistry.short_id = :namespace", {namespace: params[:namespace]}) if params[:namespace].present?

    @items = @items.where(owning_collection: params[:collection]) if  params[:collection].present?

    render json: @items
  end
end