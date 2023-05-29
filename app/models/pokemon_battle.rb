class PokemonBattle < ActiveRecord::Base
  belongs_to :pokemon1, class_name: "Pokemon", foreign_key: :pokemon1_id
  belongs_to :pokemon2, class_name: "Pokemon", foreign_key: :pokemon2_id
  belongs_to :winner, class_name: "Pokemon", foreign_key: :pokemon_winner_id, optional: true
  belongs_to :loser, class_name: "Pokemon", foreign_key: :pokemon_loser_id, optional: true

  # has_many :pokemon_battle_logs

  scope :state, -> { where(state: "ongoing") }
  validates  :pokemon1, exclusion: {in:->(record) {[record.pokemon2]}, message: "can't be the same" }
  validate   :pokemons_are_not_in_battle?
  private

  def pokemons_are_not_in_battle?
    ongoing_battle = PokemonBattle.state.where.not(id: self.id)
    pokemon1_battles = ongoing_battle.select { |pokemon_battle| pokemon_battle.pokemon1_id == pokemon1.id || pokemon_battle.pokemon2_id == pokemon1_id}
    pokemon2_battles = ongoing_battle.select { |pokemon_battle| pokemon_battle.pokemon2_id == pokemon2.id || pokemon_battle.pokemon1_id == pokemon2_id}

    if pokemon1_battles.present?
      errors.add(:pokemon1_id, "Pokemon has been ongoing battle")
    end

    if pokemon2_battles.present?
      errors.add(:pokemon2_id, "Pokemon has been ongoing battle")
    end
  end

end
