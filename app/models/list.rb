class List < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :title
  
  def self.search(search)
    if search
      where('lower(title) LIKE lower(?)', "%#{search}%")
    else
      all
    end
  end
  
  def self.only_user(user)
    where(user_id: user)
  end

end
