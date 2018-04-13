class Comment < ActiveRecord::Base
  validates :title, presence: true

end
