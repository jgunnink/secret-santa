class List < ActiveRecord::Base

  belongs_to :user, foreign_key: true
  has_many :santas

  validates :name, presence: true

end
