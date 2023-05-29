# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'pokemonpokedex.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  t = Pokedex.new
  t.name = row['name']
  t.base_health_point = row['base_health_point']
  t.base_attack = row['base_attack']
  t.base_defence = row['base_defence']
  t.base_speed = row['base_speed']
  t.element_type = row['element_type']
  t.image_url = row['image_url']
  t.save
  puts "#{t.name} saved"
end

csv_skill = File.read(Rails.root.join('lib', 'seeds', 'skill.csv'))
csv = CSV.parse(csv_skill, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  t = Skill.new
  t.name = row['name']
  t.power = row['power']
  t.max_pp = row['max_pp']
  t.element_type = row['element_type']
  t.save
  puts "#{t.name}, #{t.power} saved"
end

csv_evolution = File.read(Rails.root.join('lib', 'seeds', 'pokemonevolution.csv'))
csv = CSV.parse(csv_evolution, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  t = PokemonEvolution.new
  t.pokedex_from_name = row['pokedex_from_name']
  t.pokedex_to_name = row['pokedex_to_name']
  t.minimum_level = row['minimum_level']
  t.save
  puts "#{t.pokedex_from_name}, #{t.minimum_level} saved"
end


puts "There are now #{Pokedex.count} rows in the pokedexes table"
puts "There are now #{Skill.count} rows in the skills table"
puts "There are now #{PokemonEvolution.count} rows in the pokemon evolutions table"