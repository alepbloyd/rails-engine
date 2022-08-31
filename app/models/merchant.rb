class Merchant < ApplicationRecord
  has_many :items

  def self.case_insensitive_search(search_string)
    where("lower(name) LIKE ?", "%#{search_string.downcase}%").order('name DESC').limit(1)
  end
end
