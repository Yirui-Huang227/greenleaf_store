# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "csv"
require "faker"

puts "Cleaning old data..."
AdminUser.destroy_all
Categorization.destroy_all
Product.destroy_all
Category.destroy_all

if Rails.env.development?
  AdminUser.create!(email: "admin@example.com", password: "password",
                    password_confirmation: "password")
end

puts "Seeding categories and products from CSV..."

csv_file = Rails.root.join("db/products.csv")

CSV.foreach(csv_file, headers: true) do |row|
  product = Product.create!(
    name:        row["name"],
    description: row["description"],
    price:       row["price"],
    on_sale:     Faker::Boolean.boolean(true_ratio: 0.3),
    quantity:    Faker::Number.between(from: 5, to: 50)
  )

  category_names = row["category_names"].to_s.split("|").map(&:strip).uniq

  category_names.each do |category_name|
    category = Category.find_or_create_by!(name: category_name) do |c|
      c.description = "#{category_name} products"
    end

    Categorization.find_or_create_by!(
      product:  product,
      category: category
    )
  end
end

puts "CSV products created: #{Product.count}"
puts "Categories created: #{Category.count}"
puts "Categorizations created: #{Categorization.count}"

puts "Seeding done!"
