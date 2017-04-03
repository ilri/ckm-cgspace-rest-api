class ItemSerializer < ApplicationSerializer
  attribute :item_id, key: :id

  attribute :collection do
    object.collection.metadata.where(resource_type_id: Rails.configuration.x.COLLECTION).each do |metadatum|
      if metadatum.field.field_type.short_id == 'dc' and metadatum.field.element == 'title'
        @title = metadatum.text_value
      end
    end
    @title
  end

  attribute :handle do
    self.full_handle
  end

  attribute :thumbnail do
    self.thumbnail
  end

  has_many :metadata do
    @public_metadata = []
    object.metadata.each do |metadatum|
      if metadatum.field.qualifier != 'provenance'  # remove private metadata
        @public_metadata.push(metadatum)
      end
    end
    @public_metadata
  end

  def thumbnail
    object.bitstreams.each do |bitstream|
      bitstream.metadata.each do |metadatum|
        if metadatum.text_value.end_with?(".jpg") then
          @thumb = metadatum.text_value
        end
      end
    end

    if !@thumb.nil? then
      Rails.configuration.base_thumbnail_url + "#{self.handle}/#{@thumb}"
    else
      Rails.configuration.default_thumbnail_url
    end
  end

  def handle
    !object.handle.nil? ? object.handle.handle : ''
  end

  def full_handle
    !object.handle.nil? ? Rails.configuration.base_handle_url + object.handle.handle : ''
  end
end
