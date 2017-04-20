class ItemsController < ApplicationController
  def index
    @options = self.options(params)

    @items = Item.paginate(page: @options[:page], per_page: @options[:limit]).order(@options[:order]).distinct.joins(:field_types)

    @items = @items.where("metadatavalue.text_value like :metadata_value", {metadata_value: "%#{params[:value]}%"}) if params[:value].present?
    @items = @items.where("metadatafieldregistry.element = :element", {element: params[:element]}) if params[:element].present?
    @items = @items.where("metadatafieldregistry.qualifier = :qualifier", {qualifier: params[:qualifier]}) if params[:qualifier].present?
    @items = @items.where("metadataschemaregistry.short_id = :namespace", {namespace: params[:namespace]}) if params[:namespace].present?

    if params[:community].present?
      @community = Community.find(params[:community])
      @items = @items.joins(:communities).where("community.community_id IN (?)", @community.getSubcommunityIds) if @community.present?
    end

    @items = @items.where(owning_collection: params[:collection]) if params[:collection].present?

    response = {
        items: ActiveModel::Serializer::CollectionSerializer.new(@items, each_serializer: ItemSerializer, root: false),
        options: meta_attributes(@items, {params: params.except(:page, :controller, :action)})
    }

    render json: response
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

  def meta_attributes(collection, extra_meta = {})
    {
        current_page: collection.current_page,
        next_page: collection.next_page,
        prev_page: collection.previous_page,
        total_pages: collection.total_pages,
        total_count: collection.total_entries
    }.merge(extra_meta)
  end

end