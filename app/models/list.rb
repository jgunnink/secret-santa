class List < ActiveRecord::Base

  belongs_to :user
  has_many :santas, dependent: :destroy, inverse_of: :list

  accepts_nested_attributes_for :santas, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true
  validates :gift_day, presence: true
  validates :gift_value, numericality: { greater_than: 0, less_than: 10_000 },
                         allow_blank: true

  validate :gift_day_cannot_be_in_the_past, on: :create
  validate :cannot_be_changed, on: :update

  def gift_day_cannot_be_in_the_past
    if gift_day.present? && gift_day < Time.zone.today
      errors.add(:gift_day, "You can't set the gift day to be in the past")
    end
  end

private

  def cannot_be_changed
    if is_locked
      errors.add(:is_locked, "List has been locked and Santas already emailed.")
    end
  end

end
