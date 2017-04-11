class Handle < ApplicationRecord
  self.primary_key = "handle_id"
  self.table_name = "handle"

  has_one :item, -> { where(resource_type_id: Rails.configuration.x.ITEM) }, :foreign_key => "resource_id"
end