class Item < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  def self.find_all_case_insensitive(search_string)
    where("lower(name) LIKE ?", "%#{search_string.downcase}%").order(:name)
  end
end