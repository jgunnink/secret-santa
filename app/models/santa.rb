class Santa < ActiveRecord::Base

  belongs_to :list, inverse_of: :santas
  has_one :recipient, class_name: "Santa", foreign_key: "giving_to"
  belongs_to :giver, class_name: "Santa"

  validates :list, presence: true
  validates :name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :email, presence: true, format: { with: User::EMAIL_REGEX }
  validates :email, uniqueness: { scope: :list_id }

end
