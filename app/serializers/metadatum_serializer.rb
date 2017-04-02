class MetadatumSerializer < ApplicationSerializer
  attribute :text_value, key: :value
  attribute :element do
    object.field.element
  end
  attribute :qualifier do
    object.field.qualifier
  end
  attribute :namespace do
    object.field.field_type.short_id
  end

  belongs_to :field
end
