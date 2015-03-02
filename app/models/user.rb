class User < ActiveRecord::Base
  before_save {self.email = email.downcase}
  validates :user_name, presence: true, length: {maximum: 50}

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@brandeis.edu/i
  validates :email, presence: true, length: {maximum: 255}, 
                    format: {with: VALID_EMAIL_REGEX, message: "has to be a valid Brandeis email."},
                    uniqueness: {case_sensitive: false}
end
