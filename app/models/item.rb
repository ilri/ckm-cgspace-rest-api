class Item < ApplicationRecord
  self.primary_key = "item_id"
  self.table_name = "item"

  has_one :handle, -> { where(resource_type_id: Rails.configuration.x.ITEM) },:foreign_key => "resource_id"
  has_many :metadata, -> { where(resource_type_id: Rails.configuration.x.ITEM) }, :foreign_key => "resource_id"
  has_many :fields, :through => :metadata
  has_many :item_bundles, :foreign_key => "item_id"
  has_many :bundles, :through => :item_bundles
  has_many :bitstreams, :through => :bundles

  belongs_to :collection, :foreign_key => "owning_collection"
end