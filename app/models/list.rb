class List < ActiveRecord::Base

  belongs_to :user, foreign_key: true

  validates :name, presence: true

end
