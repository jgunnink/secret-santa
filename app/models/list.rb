class List < ActiveRecord::Base

  belongs_to :user, foreign_key: true
  has_many :santas, dependent: :destroy, foreign_key: "list_id"

  validates :name, presence: true

end
