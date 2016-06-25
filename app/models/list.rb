class List < ActiveRecord::Base

  belongs_to :user, foreign_key: true
  has_many :santa_lists, inverse_of: :list
  has_many :santas, through: :santa_lists

  validates :name, presence: true

  accepts_nested_attributes_for :santas

end
