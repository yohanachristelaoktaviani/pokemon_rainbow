class PokemonSkill < ActiveRecord::Base
  belongs_to :pokemon
  belongs_to :skill
end
