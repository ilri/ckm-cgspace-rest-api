class CollectionItem < ApplicationRecord
  self.primary_key = "id"
  self.table_name = "collection2item"

  belongs_to :collection, foreign_key: "collection_id"
  belongs_to :item, foreign_key: "item_id"
end