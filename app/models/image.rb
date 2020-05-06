class Image < ApplicationRecord

  belongs_to :item  ## 追加

  mount_uploader :src, ImageUploader
end
