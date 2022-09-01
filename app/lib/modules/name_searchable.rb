module NameSearchable

  def find_one_by_name(search_string)
    where("lower(name) LIKE ?", "%#{search_string.downcase}%").order(name: :desc).first
  end

  def self.find_all_by_name(search_string)

  end

end