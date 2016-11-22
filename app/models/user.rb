class User < ActiveRecord::Base
  EMAIL_REGEX = /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :confirmable

  # Soft delete - uses deleted_at field
  acts_as_paranoid

  enum role: { admin: 0, member: 1 }

  validates :given_names, presence: true, length: { minimum: 2, maximum: 20 }
  validates :email, presence: true
  validates :email, format: { with: EMAIL_REGEX, allow_blank: true }, if: :email_changed?
  validates :email, uniqueness: { scope: :deleted_at }, unless: :deleted?
  validates :password, presence: true, confirmation: true, on: :create
  validates :password, length: { within: Devise.password_length, allow_blank: true }
  validates :role, presence: true

  has_many :lists, dependent: :destroy

  def to_s
    email
  end

  # Override Devise notification to use background messaging queue.
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

end
