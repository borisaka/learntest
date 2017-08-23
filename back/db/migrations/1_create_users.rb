Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :email, index: {unique: true}
      String :first_name
      String :last_name
      String :role, default: 'user'
      String :password_hash
    end
  end
end
