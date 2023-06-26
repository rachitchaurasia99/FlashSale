desc "Generates Token"
namespace :user do
  task :generate_token, [:email] => :environment do |t, args|
    user = User.find_by(email: args[:email])
    user.regenerate_auth_token
  end
end
