require 'import'
class UsersRepo
  include Import['db']
  def create(attrs)
    id = db[:users].insert(attrs)
    attrs.merge(id: id)
  end

  def lookup(id)
    db[:users].where(id: id).first
  end

  def by_email(email)
    db[:users].where(email: email).first
  end

  def list
    db[:users].all
  end

  def update(id, new_attrs)
    db[:users].where(id: id).update(new_attrs)
    lookup(id)
  end
end
