class Item < ApplicationRecord
  self.primary_key = "item_id"
  self.table_name = "item"

  has_one :handle, -> { where(resource_type_id: Rails.configuration.x.ITEM) },foreign_key: "resource_id"
  has_many :metadata, -> { where(resource_type_id: Rails.configuration.x.ITEM) }, foreign_key: "resource_id"
  has_many :fields, through: :metadata
  has_many :field_types, through: :fields
  has_many :item_bundles, foreign_key: "item_id"
  has_many :bundles, through: :item_bundles
  has_many :bitstreams, through: :bundles

  has_many :collections, through: :collection_items
  has_many :collection_items, foreign_key: :item_id

  has_many :communities, through: :collections

  belongs_to :collection, :foreign_key => "owning_collection"

  def self.with_metadatum(metadatum)
    @items = Item.joins(:field_types)
    @items = @items.where("metadataschemaregistry.short_id = :namespace", {namespace: metadatum[:namespace]}) if metadatum[:namespace].present?
    @items = @items.where("metadatafieldregistry.element = :element", {element: metadatum[:element]}) if metadatum[:element].present?
    @items = @items.where("metadatafieldregistry.qualifier = :qualifier", {qualifier: metadatum[:qualifier]}) if metadatum[:qualifier].present?
    @items = @items.where("metadatavalue.text_value ILIKE :value", {value: "%#{metadatum[:value]}%"}) if metadatum[:value].present?
    @items.pluck("item_id")
  end
end