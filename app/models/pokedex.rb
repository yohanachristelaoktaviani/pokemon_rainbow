class Pokedex < ActiveRecord::Base
  has_one  :pokemon, dependent: :destroy
  has_many :pokemon_battles, dependent: :destroy
end
