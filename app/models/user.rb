class User < ActiveRecord::Base

  validates :user_name, :password_digest, :session_token, presence: true, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }

  after_initialize :ensure_session_token

  attr_reader :password

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64(32)
    self.save
    self.session_token
  end

  def password=(pw)
    @password = pw
    pw_digest = BCrypt::Password.create(pw)
    self.password_digest = pw_digest
  end

  def is_password?(pw)
    pw_dig = BCrypt::Password.new(self.password_digest)
    pw_dig.is_password?(pw)
  end

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64(32)
  end

  def self.find_by_credentials(user_name, pw)
    potential_user = User.find_by({user_name: user_name})
    return nil unless potential_user
    potential_user.is_password?(pw) ? potential_user : nil
  end

end#class
