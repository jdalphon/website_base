class BlogPost < ActiveRecord::Base
  
  belongs_to :user

  def self.search(search)
    if search
      where('lower(title) LIKE lower(?)', "%#{search}%")
    else
      all
    end
  end

  def self.only_category(category)
    if category
      where('category LIKE ?', "%#{category}%")
    else
      all
    end
  end
end
