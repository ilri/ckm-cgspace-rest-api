class Item < ApplicationRecord
  self.primary_key = "item_id"
  self.table_name = "item"

  has_one :handle, :foreign_key => "resource_id"
  has_many :metadata, :foreign_key => "resource_id"
  has_many :fields, :through => :metadata
  has_many :item_bundles, :foreign_key => "item_id"
  has_many :bundles, :through => :item_bundles
  has_many :bitstreams, :through => :bundles
end