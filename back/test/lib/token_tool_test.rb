require "test_helper"
class TokenToolTest < Minitest::Test
  def setup
    @subject = Application['token_tool'] 
    @secret = Application['runtime.secret']
    @user = {id: 1} 
  end

  def test_to_payload
    expected = JWT.encode({id: 1}, @secret, 'HS256')
    assert_equal expected, @subject.to_payload(@user)
  end

  def test_from_payload
    payload = JWT.encode({id: 1}, @secret, 'HS256')
    decoded = {id: 1}
    assert_equal decoded, @subject.from_payload(payload)
  end
end
