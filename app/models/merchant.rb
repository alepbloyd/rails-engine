class Merchant < ApplicationRecord
  has_many :items

  def self.case_insensitive_search(search_string)
    where("lower(name) LIKE ?", "%#{search_string.downcase}%")
  end
end
