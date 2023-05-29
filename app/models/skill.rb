class Skill < ActiveRecord::Base
  has_many :pokemon_skills
  has_many :pokemons, through: :pokemon_skills
end
