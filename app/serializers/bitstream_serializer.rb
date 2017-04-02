class BitstreamSerializer < ApplicationSerializer
  attribute :thumbnail do
    @thumbnails = object.metadata.where("text_value LIKE '%.jpg'")
    if @thumbnails[0] then
      @thumbnails[0].text_value
    end
  end
end
