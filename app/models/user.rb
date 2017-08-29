class User < ApplicationRecord
  has_many :posts
  before_create :create_remember_token
	before_save   :downcase_email
	
	validates :name, presence: true, length: {minimum: 5, maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 255},
									  format: {with: VALID_EMAIL_REGEX },
									  uniqueness: {case_sensitive: false}

	has_secure_password
	VALID_PASSWORD_REGEX = /(?=\w*[a-z])(?=\w*[0-9])\w+/
	validates :password, presence: true, length: {minimum: 6},
											 format: {with: VALID_PASSWORD_REGEX}, allow_nil: true

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

    # Converts email to all lower-case.
    def downcase_email
      email.downcase!
    end

end