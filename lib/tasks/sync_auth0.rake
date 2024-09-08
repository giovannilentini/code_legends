namespace :auth0 do
  task sync_to_redis: :environment do
    Auth0Service.get_users.each do |user|
      User.find_or_create_by(auth0_id: user["user_id"]) do |user_create|
          user_create.username = user["username"] != nil ? user["username"] : user["nickname"]
          user_create.email = user["email"]
          user_create.is_admin = false
          user_create.auth0_id = user["user_id"]
        end
      end
    puts "Auth0 database synced to local DB!"
  end
end
