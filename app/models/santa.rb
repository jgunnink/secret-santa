class Santa < ActiveRecord::Base

  has_many :santa_lists, inverse_of: :lists
  has_many :lists, through: :santa_lists

  validates :name, presence: true

end
