require 'jwt'
require 'import'
class TokenTool
  include Import['runtime.secret'] 
  def to_payload(user)
    payload = {id: user[:id]} 
    JWT.encode payload, secret, 'HS256'
  end

  def from_payload(token)
    payload = JWT.decode(token, secret, true, { :algorithm => 'HS256' })[0]
    Hash[payload.map {|k,v| [k.to_sym, v]}]
  end
end
