class List < ActiveRecord::Base

  belongs_to :user
  has_many :santas, dependent: :destroy

  accepts_nested_attributes_for :santas, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true
  validates :gift_day, presence: true

  validate :gift_day_cannot_be_in_the_past, on: :create

  def gift_day_cannot_be_in_the_past
    if gift_day.present? && gift_day < Date.today
      errors.add(:gift_day, "You can't set the gift day to be in the past")
    end
  end

end
