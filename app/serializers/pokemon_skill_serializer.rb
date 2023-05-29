class PokemonSkillSerializer < ActiveModel::Serializer
  attributes :skill_id, :current_pp, :_destroy
end
