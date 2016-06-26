class List < ActiveRecord::Base

  belongs_to :user, foreign_key: true
  has_many :santas, dependent: :destroy

  accepts_nested_attributes_for :santas, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true

end
