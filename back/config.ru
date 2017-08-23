require 'roda/rest_api'
require 'json'
require 'rack/parser'

require_relative 'system/container'
Application.finalize!

class AppendUserRole 
  def initialize(app)
    @app = app
  end
  def call(env)
    token = env['HTTP_AUTHORIZATION']&.gsub('Bearer ','')
    if token
      user = Application['token_tool'].from_payload(token)
      env['session.role'] = Application['users_repo'].lookup(user[:id])[:role]
    end
    @app.call(env)
  end
end

class App < Roda
  plugin :rest_api
  plugin :json_parser
  plugin :json
  plugin :halt

  opts[:users_repo] = Application['users_repo']
  opts[:auth_tool] = Application['auth_tool']
  opts[:password_tool] = Application['password_tool']

  route do |r|
    r.api do
      r.version 1 do

        r.resource "sessions" do |session|
          session.save do
            credentials = env['rack.parser.result'].values_at('email', 'password')
            tok_hash = opts[:auth_tool].authenticate(*credentials)
            tok_hash
          end
        end

        r.resource "users" do |users|
          users.list  do
            r.halt(401, []) unless env['session.role'] == 'admin'
            opts[:users_repo].list
          end
          users.save do |attrs|
            r.halt(401, []) unless env['session.role'] == 'admin'
            data = env['rack.parser.result']
            data.delete('password_hash') if data['password_hash']
            password = data.delete('password')
            data['password_hash'] = opts[:password_tool].generate('password') if password
            if attrs[:id] 
              opts[:users_repo].update(attrs[:id].to_i, data)
            else
              opts[:users_repo].create(data)
            end
          end
          users.one do |params| 
            r.halt(401, []) unless env['session.role'] == 'admin'
            opts[:users_repo].lookup(params[:id]) 
          end
        end
      end
    end
  end
end

use Rack::Parser, :parsers => { 'application/json' => proc { |data| JSON.parse data }}
use AppendUserRole
run App.freeze.app
