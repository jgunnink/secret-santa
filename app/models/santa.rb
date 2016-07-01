class Santa < ActiveRecord::Base

  belongs_to :list

  validates :name, presence: true
  validates :email, presence: true, format: { with: Devise.email_regexp }
  validates :email, uniqueness: { scope: :list_id }

end
