class Pokemon < ActiveRecord::Base
  belongs_to :pokedexes, class_name: "Pokedex", foreign_key: :pokedex_id
  has_many :pokemon_skills, dependent: :destroy
  has_many :skills, through: :pokemon_skills, dependent: :destroy
  has_many :battles
  accepts_nested_attributes_for :pokemon_skills, allow_destroy: true

end
