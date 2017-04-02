class Handle < ApplicationRecord
  self.primary_key = "handle_id"
  self.table_name = "handle"

  has_one :item, :foreign_key => "resource_id"
end