require 'import'
class AuthTool
  include Import['users_repo']
  include Import['password_tool']
  include Import['token_tool']
  def authenticate(email, password)
    user = users_repo.by_email(email) 
    return false unless user
    return false unless password_tool.validate(user[:password_hash], password) 
    {token: token_tool.to_payload(user)} 
  end

  def authorized?(token, role)
    id = token_tool.from_payload(token)
    users_repo.lookup(id)&.role == role
  end
end
