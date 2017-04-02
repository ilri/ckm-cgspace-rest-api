class ItemBundle < ApplicationRecord
  self.primary_key = "id"
  self.table_name = "item2bundle"

  has_one :item, :foreign_key => "item_id"
  has_one :bundle, :foreign_key => "bundle_id"
end