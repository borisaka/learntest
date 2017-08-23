require 'test_helper'
class UsersRepoTest < Minitest::Test
  def setup
    super
    @subject = Application['users_repo']
    @db = Application['db']
    @max_id = @db[:users].max(:id) || 0
    @db[:users].truncate
  end

  def test_create
    attrs = gen_attrs
    next_id = @max_id + 1
    assert_equal attrs.merge(id: next_id), @subject.create(attrs) 
  end

  def test_lookup
    attrs_ary = (0...10).map { @subject.create(gen_attrs)} 
    sample = attrs_ary.sample
    assert_equal sample, @subject.lookup(sample[:id])
  end

  def test_list
    attrs_ary = (0...10).map { @subject.create(gen_attrs) }
    users = @subject.list
    assert_equal 10, users.length
    assert_empty users - attrs_ary 
  end

  private

  def gen_attrs
    {email: Faker::Internet.free_email,
     first_name: Faker::Name.first_name,
     last_name: Faker::Name.last_name, 
     password_hash: 'xxxxx',
     role: 'user'}
  end
end
