class User
  include Mongoid::Document
  include Mongoid::Timestamps

  include Authenticable
  acts_as_authentic do |config|
    config.validate_login_field    = false
    config.validate_email_field    = false
    config.validate_password_field = false
    config.merge_validates_uniqueness_of_login_field_options :scope => '_id', :case_sensitive => false
  end

  include Gravtastic
  gravtastic :size => 45, :filetype => "png", :secure => true

  attr_accessible :email, :username, :password

  validates :username, :presence => true, :uniqueness => { :case_sensitive => false }
  validates :email,    :presence => true, :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true

  scope :by_email, lambda{ |e| where(:email => e) }

  def self.find_by_username_or_email(login)
    User.any_of({:username => login}, {:email => login}).first
  end
end