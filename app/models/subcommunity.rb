class Subcommunity < ApplicationRecord
  self.primary_key = "id"
  self.table_name = "community2community"

  belongs_to :parent, class_name: "Community", foreign_key: "parent_comm_id"
  belongs_to :child, class_name: "Community", foreign_key: "child_comm_id"
end