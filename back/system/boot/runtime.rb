Application.finalize(:runtime) do |container|
  container.register 'runtime.secret' do
    ENV['SECRET']
  end
end
