puts "clearing all users, listings and bookings..."

User.destroy_all
Listing.destroy_all
Booking.destroy_all

puts "creating the four mangos as users..."

oliver = User.create!({
    email: "oliver@lewgon.com",
    password: "lewagon",
    address: "Löwenplatz, Luzern",
    name: "Oliver",
    phone: "44719999991"
  }
)

ioannis = User.create!({
    email: "ioannis@lewagon.com",
    password: "lewagon",
    address: "Badenerstrasse, 8048 Zürich",
    name: "Ioannis",
    phone: "0745935921"
  }
)

marlin = User.create!({
    email: "marlin@lewagon.com",
    password: "lewagon",
    address: "Verenastrasse, Zürich",
    name: "Marlin",
    phone: "0792103862"
  }
)

omar = User.create!({
    email: "omar@lewagon.com",
    password: "lewagon",
    address: "Bahnhofstrasse, Zürich",
    name: "Omar",
    phone: "0764921653"
  }
)

puts "created users!"
puts "creating 2 listings per user..."

listing3 = Listing.create!({
  name: "Menschen",
  description: "Pflege Hilfe",
  price_per_hour: 3.50,
  location: "Zürcherstrasse, 8952 Zürich",
  user_id: ioannis.id,
  category_type: "Electronic"
})

listing5 = Listing.create!({
  name: "Tierbesuch",
  description: "Katzen und Hunde",
  price_per_hour: 2,
  location: "Verenastrasse, Zürich",
  user_id: marlin.id,
  category_type: "Electronic"
})

listing6 = Listing.create!({
  name: "Volunteer Work",
  description: "Forest and Mountain",
  price_per_hour: 10,
  location: "Verenastrasse, Zürich",
  user_id: marlin.id,
  category_type: "Electronic"
})

listing7 = Listing.create!({
  name: "Helfer fur die Umwelt",
  description: "REcycling Ja!",
  price_per_hour: 20,
  location: "Bahnhofstrasse, Zürich",
  user_id: omar.id,
  category_type: "Electronic"
})

puts "created listings!"
puts "creating a few bookings..."

Booking.create!({
  start_date: Date.new(2022,11,28),
  end_date: Date.new(2022,11,28),
  listing_id: listing8.id,
  user_id: oliver.id
})

Booking.create!({
  start_date: Date.new(2022,12,9),
  end_date: Date.new(2022,12,15),
  listing_id: listing5.id,
  user_id: omar.id,
  status: "confirmed"
})

Booking.create!({
  start_date: Date.new(2023,2,3),
  end_date: Date.new(2023,2,6),
  listing_id: listing6.id,
  user_id: ioannis.id
})

Booking.create!({
  start_date: Date.new(2023,2,25),
  end_date: Date.new(2023,2,26),
  listing_id: listing1.id,
  user_id: marlin.id
})

puts "FINISHED!"
