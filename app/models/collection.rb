class Collection < ApplicationRecord
  self.primary_key = "collection_id"
  self.table_name = "collection"

  has_many :items
  has_many :metadata, :foreign_key => "resource_id"
end