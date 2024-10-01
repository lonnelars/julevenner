# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.destroy_all
Group.destroy_all
group = Group.create!(name: "Lønneblader 2024")

group.users.create!([ { name: "Lars", email: "lonnelars@gmail.com" },
  { name: "Inga", email: "inga.saether@gmail.com" },
  { name: "Erik", email: "eriklonne@gmail.com" },
  { name: "Ingeborg", email: "ingeborgtiltvik@gmail.com" },
  { name: "Mari", email: "mariwergeland@gmail.com" },
  { name: "Blake", email: "blake.wergeland@gmail.com" },
  { name: "Farmor", email: "gslonne@icloud.com" },
  { name: "Farfar", email: "ojlonne@icloud.com" } ])

def find_seed(group)
  seed = Random.new_seed
  users = group.users.all
    candidate = users.zip(users.shuffle(random: Random.new(seed)))
  if candidate.all? { |pair| pair[0] != pair[1] } then
    seed
  else
    find_seed group
  end
end

seed = find_seed group
group.seed = seed
group.save!
