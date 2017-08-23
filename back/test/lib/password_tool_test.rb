require 'test_helper'
# require 'password_tool'
class PasswordToolsTest < Minitest::Test
  # include Import['runtime.secret']
  # include Import['password_tool']
  def setup
    super
    @subject = Application['password_tool']
    @secret = Application['runtime.secret']
  end

  def test_generate
    current = @subject.generate('password')
    assert_equal BCrypt::Password.new(current), @secret + 'password'
  end

  def test_validate
    hex = BCrypt::Password.create(@secret + 'superpassword').to_s
    assert @subject.validate(hex, 'superpassword')
  end
end
