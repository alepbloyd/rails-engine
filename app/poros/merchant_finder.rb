class MerchantFinder
  attr_reader :name

  def initialize(name = nil)
    @name = name
  end

  def name_present?
    @name.present?
  end

  def search_one
    if self.name_present?
      Merchant.find_one_by_name(@name)
    else
      "No name error"
    end
  end

  def search_all
    if self.name_present?
      Merchant.find_all_by_name(@name)
    else
      "No name error"
    end
  end
end