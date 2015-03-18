class User < ActiveRecord::Base
  has_many :attendances
  has_many :events, through: :attendances
  before_save :downcase_fields
  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@brandeis.edu/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: {with: VALID_EMAIL_REGEX,
                             message: "has to be a valid Brandeis email."},
                    uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, length: { minimum: 5 }

  private
    def downcase_fields
      self.name.downcase!
      self.email.downcase!
    end
end
