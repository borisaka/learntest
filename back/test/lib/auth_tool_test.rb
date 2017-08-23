require 'test_helper'
class AuthToolTest < Minitest::Test
  def setup
    super
    @subject = Application['auth_tool']
  end

  def test_authenticate
    @subject.users_repo.stubs(:by_email).with('me@example.com').returns({id: 4, password_hash: '0'})
    @subject.users_repo.stubs(:by_email).with('you@example.com').returns({id: 1, password_hash: '1'})
    @subject.users_repo.stubs(:by_email).with('us@example.com').returns(nil)
    @subject.password_tool.stubs(:validate).with('0','password').returns(true)
    @subject.password_tool.stubs(:validate).with('1','password').returns(false)
    @subject.token_tool.stubs(:to_payload).with({id: 4, password_hash: '0'}).returns('TOKEN')
    assert_equal({token: 'TOKEN'}, @subject.authenticate('me@example.com', 'password'))
    refute @subject.authenticate('you@example.com', 'password')
    refute @subject.authenticate('us@example.com', 'password')
  end

end
