class PokemonSerializer < ActiveModel::Serializer
  attributes :pokedex_id, :name, :max_health_point, :current_health_point, :attack, :defence, :speed, :current_experience, :level
  has_many   :pokemon_skills
end
