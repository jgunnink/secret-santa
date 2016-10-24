class List < ActiveRecord::Base

  belongs_to :user
  has_many :santas, dependent: :destroy, inverse_of: :list

  accepts_nested_attributes_for :santas, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :gift_day, presence: true
  validates :gift_value, numericality: { greater_than: 0, less_than: 10_000, only_integer: true },
                         allow_blank: true

  validate :gift_day_cannot_be_in_the_past, on: [:create, :update]
  validate :cannot_be_changed, on: :update
  validate :list_size_limit

  def gift_day_cannot_be_in_the_past
    if gift_day.present? && gift_day < Time.zone.today
      errors.add(:gift_day, "You can't set the gift day to be today or in the past")
    end
  end

  def list_size_limit
    errors.add(:santa, "This list is limited to 15 Santas") if santas.size > 15
  end

private

  def cannot_be_changed
    if is_locked
      errors.add(:is_locked, "List has been locked and Santas already emailed.")
    end
  end

end
