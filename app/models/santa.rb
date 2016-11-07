class Santa < ActiveRecord::Base

  belongs_to :list, inverse_of: :santas

  validates :list, presence: true
  validates :name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :email, presence: true, format: { with: Devise.email_regexp }
  validates :email, uniqueness: { scope: :list_id }

end
