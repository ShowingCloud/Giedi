namespace :db do

  namespace :export_user do

    desc "Create CSV Files for User Model"
    task :csv => :environment do
      require "#{Rails.root}/app/models/user.rb"
      dir = "#{Rails.root}/db/csv"
      FileUtils.mkdir(dir) unless Dir.exists?(dir)
      unless File.exists?("#{dir}/#{User.to_s.tableize}.csv")
        CSV.open("#{dir}/#{User.to_s.tableize}.csv", 'w+') do |csv|
            csv << User.column_names
            User.all.each do |user|
              csv << User.column_names.map{ |attr| user.send(attr) }
            end
        end
        puts "CREATED FILE >> #{User.to_s.tableize}.csv"
      end

    end
  end

  namespace :import_user do

    desc "import user data from CSV"
    task :csv => :environment do
      require "#{Rails.root}/app/models/user.rb"
      CSV.foreach("#{Rails.root}/db/csv/users.csv", headers: true) do |row|
        user_hash = row.to_hash
        confirmed = user_hash["confirmed_at"].present? ? true : false
        User.create!(id:user_hash["id"], name: user_hash["nickname"], email: user_hash["email"], phone: user_hash["mobile"],confirmed:confirmed, confirmed_at: user_hash["confirmed_at"],password_digest: user_hash["encrypted_password"])
      end
    end
  end

end
