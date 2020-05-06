class Category < ApplicationRecord

  has_ancestry  ## 追加

  validates :name, presence: true

  has_many :items
end
