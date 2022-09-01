class Merchant < ApplicationRecord
  extend Searchable

  has_many :items
end
