# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :session_token, presence: true 
  validates :password, length: {minimum: 6 , allow_nil: true }
  after_initialize :ensure_session_token
  
  has_many :cats,
  foreign_key: :user_id,
  class_name: :Cat
  
  
  attr_reader :password
  
  def self.find_by_credentials(username,password)
    user = User.find_by(username: username )
    return user if user && user.is_password?(password)
    nil
  end
  
  def is_password?(pw)
    BCrypt::Password.new(self.password_digest).is_password?(pw)
  end
  
  def password=(pw)
    @password = pw
    # byebug
    self.password_digest = BCrypt::Password.create(pw)
  end
  
  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end
  
  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end
  
end
