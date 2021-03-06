require 'bcrypt'

class User
  include DataMapper::Resource

  attr_reader :password
  attr_accessor :password_confirmation

  # validates_presence_of :email #model level validation not strictly required as we are setting email field as 'required' at db level below
  validates_presence_of :password
  validates_format_of :email, as: :email_address
  validates_uniqueness_of :email
  
  validates_confirmation_of :password

  property :id, Serial
  property :email, String, format: :email_address, required: true#, unique: true
  property :password_digest, String, length: 60

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(args)
    user = first(email: args[:email])
    if user && BCrypt::Password.new(user.password_digest) == args[:password]
      user
    else
      nil
    end    
  end

end


