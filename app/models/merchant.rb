require './app/lib/modules/name_searchable.rb'

class Merchant < ApplicationRecord
  extend NameSearchable

  has_many :items
end
