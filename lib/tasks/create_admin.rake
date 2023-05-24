namespace :admin do
  desc "Create Admin User"
  task :new => :environment do

    admin = User.new

    puts "Enter admin's first name: "
    admin.first_name = STDIN.gets.chomp

    puts "Enter admin's last name: "
    admin.last_name = STDIN.gets.chomp

    puts "Enter an email address: "
    admin.email = STDIN.gets.chomp

    puts "Enter a password: "
    admin.password = STDIN.gets.chomp

    puts "Please confirm your password: "
    admin.password_confirmation = STDIN.gets.chomp

    admin.skip_confirmation!

    if admin.save
      puts "The admin was created successfully"
    else
      admin.errors.full_messages.each { |full_message| puts full_message }
      puts "Sorry, the admin was not created!"
    end
  end
end
