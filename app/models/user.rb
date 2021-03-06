class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_writer :login

  def login
    @login || username || email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    elsif conditions.key?(:username) || conditions.key?(:email)
      where(conditions.to_h).first
    end
  end

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, multiline: true

  has_one_attached :avatar
  has_many :bookings
  has_many :products
  has_many :favourites
  has_many :reviews, through: :bookings
  has_many :messages, dependent: :destroy
  has_many :author_chatrooms, foreign_key: :p1_id, class_name: 'Chatroom', dependent: :destroy
  has_many :receiver_chatrooms, foreign_key: :p2_id, class_name: 'Chatroom', dependent: :destroy
  has_many :notifications, foreign_key: :recipient_id



end
