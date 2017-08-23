require 'bcrypt'
require 'import'
# Password hex creating and validatig service object
# uses @secret property as a secret
class PasswordTool
  include Import['runtime.secret']
  # def initialize(secret)
  #   raise 'Bad secret' unless secret.is_a?(String)
  #   @secret = secret
  # end

  def generate(password)
    BCrypt::Password.create(secret + password).to_s
  end

  def validate(hex, password)
    current = BCrypt::Password.new(hex)
    current == secret + password
  end
end
