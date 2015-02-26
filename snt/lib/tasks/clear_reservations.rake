namespace :pms do
  desc "Clear all reservations"
  task :clear_reservations, [:hotel_code] => :environment do |task, args|
    if !Rails.env.production?
      hotel = Hotel.find_by_code(args[:hotel_code])
      hotel.reservations.destroy_all
    else
      p "Destroying all reservations not allowed in production"
    end
  end
end