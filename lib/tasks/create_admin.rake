namespace :admin do
  desc "Create Admin User"
  task :new => :environment do
    puts "Enter an email address: "
    email = STDIN.gets
    puts "Enter a password: "
    password = STDIN.gets
    unless email.strip!.blank? || password.strip!.blank?
      user = User.new(role: 'admin', email: email, password: password)
      user.skip_confirmation!
      if user.save
        puts "The admin was created successfully"
      else
        puts "Sorry, the admin was not created!"
      end
    end
  end
end
