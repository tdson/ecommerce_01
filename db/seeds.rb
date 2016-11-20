# Create users
User.create! email: "admin@ecommerce.com",
  password: "123456",
  name: "Root Admin",
  role: User.roles[:admin],
  gender: Settings.male_gender,
  chatwork_id: "sontd",
  confirmed_at: Time.now

(2..5).each do |n|
  name = Faker::Name.name
  email = "mod_#{n}@ecommerce.com"
  User.create! email: email,
    name: name,
    password: "123456",
    role: User.roles[:mod],
    gender: Settings.male_gender,
    confirmed_at: Time.now
end

(6..25).each do |n|
  name = Faker::Name.name
  email = "user_#{n}@ecommerce.com"
  User.create! email: email,
    name: name,
    password: "123456",
    role: User.roles[:member],
    gender: Settings.female_gender,
    confirmed_at: Time.now
end

# Catagories
5.times do
  Category.create! name: Faker::Team.sport,
    description: Faker::Lorem.sentence(10)
end
# Sub categories
10.times do
  category = Category.create! name: Faker::Team.creature,
    description: Faker::Lorem.sentence(10)
  5.times do |n|
    category.products.create! name: "product #{category.name} #{n}",
      description: Faker::Lorem.sentence(20),
      price: rand(1..1000),
      quantity: rand(1..99)
  end
end

# Orders
=begin
10.times do |n|
  order = Order.create! user_id: rand(1..5), status: rand(0..2)
  products = Product.order("RAND()").take(rand(2..5))
  products.each do |product|
    order.order_products.create! product_id: product.id,
      quantity: rand(1..5),
      current_price: product.price
  end
end
=end
