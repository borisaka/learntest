require 'sequel'
Application.finalize(:db) do
  start do
    container.register 'db', Sequel.connect(ENV['DATABASE_URL'])
  end

  stop do
    container.resolve('db').close
  end
end
