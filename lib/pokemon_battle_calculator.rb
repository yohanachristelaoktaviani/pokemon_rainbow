class PokemonBattleCalculator
    TYPE_CHART = {
      normal:   { normal: 1.0,  fire: 1.0,  water: 1.0,  electric: 1.0,  grass: 1.0,  ice: 1.0,  fighting: 1.0,  poison: 1.0,  ground: 1.0,  flying: 1.0,  psychic: 1.0,  bug: 1.0,  rock: 0.5,  ghost: 0.0,  dragon: 1.0,  dark: 1.0,  steel: 0.5,  fairy: 1.0 },
      fire:     { normal: 1.0,  fire: 0.5,  water: 0.5,  electric: 1.0,  grass: 2.0,  ice: 2.0,  fighting: 1.0,  poison: 1.0,  ground: 1.0,  flying: 1.0,  psychic: 1.0,  bug: 2.0,  rock: 0.5,  ghost: 1.0,  dragon: 0.5,  dark: 1.0,  steel: 2.0,  fairy: 1.0 },
      water:    { normal: 1.0,  fire: 2.0,  water: 0.5,  electric: 1.0,  grass: 0.5,  ice: 1.0,  fighting: 1.0,  poison: 1.0,  ground: 2.0,  flying: 1.0,  psychic: 1.0,  bug: 1.0,  rock: 2.0,  ghost: 1.0,  dragon: 0.5,  dark: 1.0,  steel: 1.0,  fairy: 1.0 },
      electric: { normal: 1.0,  fire: 1.0,  water: 2.0,  electric: 0.5,  grass: 0.5,  ice: 1.0,  fighting: 1.0,  poison: 1.0,  ground: 0.0,  flying: 2.0,  psychic: 1.0,  bug: 1.0,  rock: 1.0,  ghost: 1.0,  dragon: 0.5,  dark: 1.0,  steel: 1.0,  fairy: 1.0 },
      grass:    { normal: 1.0,  fire: 0.5,  water: 2.0,  electric: 1.0,  grass: 0.5,  ice: 1.0,  fighting: 1.0,  poison: 0.5,  ground: 2.0,  flying: 0.5,  psychic: 1.0,  bug: 0.5,  rock: 2.0,  ghost: 1.0,  dragon: 0.5,  dark: 1.0,  steel: 0.5,  fairy: 1.0 },
      ice:      { normal: 1.0,  fire: 0.5,  water: 0.5,  electric: 1.0,  grass: 2.0,  ice: 0.5,  fighting: 1.0,  poison: 1.0,  ground: 2.0,  flying: 2.0,  psychic: 1.0,  bug: 1.0,  rock: 1.0,  ghost: 1.0,  dragon: 2.0,  dark: 1.0,  steel: 0.5,  fairy: 1.0 },
      fighting: { normal: 2.0,  fire: 1.0,  water: 1.0,  electric: 1.0,  grass: 1.0,  ice: 2.0,  fighting: 1.0,  poison: 0.5,  ground: 1.0,  flying: 0.5,  psychic: 0.5,  bug: 0.5,  rock: 2.0,  ghost: 0.0,  dragon: 1.0,  dark: 2.0,  steel: 2.0,  fairy: 0.5 },
      poison:   { normal: 1.0,  fire: 1.0,  water: 1.0,  electric: 1.0,  grass: 2.0,  ice: 1.0,  fighting: 1.0,  poison: 0.5,  ground: 0.5,  flying: 1.0,  psychic: 2.0,  bug: 2.0,  rock: 0.5,  ghost: 0.5,  dragon: 1.0,  dark: 1.0,  steel: 0.0,  fairy: 2.0 },
      ground:   { normal: 1.0,  fire: 2.0,  water: 1.0,  electric: 2.0,  grass: 0.5,  ice: 1.0,  fighting: 1.0,  poison: 2.0,  ground: 1.0,  flying: 0.0,  psychic: 1.0,  bug: 0.5,  rock: 2.0,  ghost: 1.0,  dragon: 1.0,  dark: 1.0,  steel: 2.0,  fairy: 1.0 },
      flying:   { normal: 1.0,  fire: 1.0,  water: 1.0,  electric: 0.5,  grass: 2.0,  ice: 1.0,  fighting: 2.0,  poison: 1.0,  ground: 1.0,  flying: 1.0,  psychic: 1.0,  bug: 2.0,  rock: 0.5,  ghost: 1.0,  dragon: 1.0,  dark: 1.0,  steel: 0.5,  fairy: 1.0 },
      psychic:  { normal: 1.0,  fire: 1.0,  water: 1.0,  electric: 1.0,  grass: 1.0,  ice: 1.0,  fighting: 2.0,  poison: 2.0,  ground: 1.0,  flying: 1.0,  psychic: 0.5,  bug: 1.0,  rock: 1.0,  ghost: 1.0,  dragon: 1.0,  dark: 0.0,  steel: 0.5,  fairy: 1.0 },
      bug:      { normal: 1.0,  fire: 0.5,  water: 1.0,  electric: 1.0,  grass: 2.0,  ice: 1.0,  fighting: 0.5,  poison: 0.5,  ground: 1.0,  flying: 0.5,  psychic: 2.0,  bug: 1.0,  rock: 1.0,  ghost: 0.5,  dragon: 1.0,  dark: 2.0,  steel: 0.5,  fairy: 0.5 },
      rock:     { normal: 1.0,  fire: 2.0,  water: 1.0,  electric: 1.0,  grass: 1.0,  ice: 2.0,  fighting: 0.5,  poison: 1.0,  ground: 0.5,  flying: 2.0,  psychic: 1.0,  bug: 2.0,  rock: 1.0,  ghost: 1.0,  dragon: 1.0,  dark: 1.0,  steel: 0.5,  fairy: 1.0 },
      ghost:    { normal: 0.0,  fire: 1.0,  water: 1.0,  electric: 1.0,  grass: 1.0,  ice: 1.0,  fighting: 1.0,  poison: 1.0,  ground: 1.0,  flying: 1.0,  psychic: 2.0,  bug: 1.0,  rock: 1.0,  ghost: 2.0,  dragon: 1.0,  dark: 0.5,  steel: 1.0,  fairy: 1.0 },
      dragon:   { normal: 1.0,  fire: 1.0,  water: 1.0,  electric: 1.0,  grass: 1.0,  ice: 1.0,  fighting: 1.0,  poison: 1.0,  ground: 1.0,  flying: 1.0,  psychic: 1.0,  bug: 1.0,  rock: 1.0,  ghost: 1.0,  dragon: 2.0,  dark: 1.0,  steel: 0.5,  fairy: 2.0 },
      dark:     { normal: 1.0,  fire: 1.0,  water: 1.0,  electric: 1.0,  grass: 1.0,  ice: 1.0,  fighting: 0.5,  poison: 1.0,  ground: 1.0,  flying: 1.0,  psychic: 2.0,  bug: 1.0,  rock: 1.0,  ghost: 2.0,  dragon: 1.0,  dark: 0.5,  steel: 1.0,  fairy: 0.5 },
      steel:    { normal: 1.0,  fire: 0.5,  water: 0.5,  electric: 0.5,  grass: 1.0,  ice: 2.0,  fighting: 1.0,  poison: 1.0,  ground: 1.0,  flying: 1.0,  psychic: 1.0,  bug: 1.0,  rock: 2.0,  ghost: 1.0,  dragon: 1.0,  dark: 1.0,  steel: 0.5,  fairy: 2.0 },
      fairy:    { normal: 1.0,  fire: 0.5,  water: 1.0,  electric: 1.0,  grass: 1.0,  ice: 1.0,  fighting: 2.0,  poison: 0.5,  ground: 1.0,  flying: 1.0,  psychic: 1.0,  bug: 1.0,  rock: 1.0,  ghost: 1.0,  dragon: 2.0,  dark: 2.0,  steel: 0.5,  fairy: 1.0 }
    }.freeze

  def self.calculate_damage(attacker:, defender:, skill:)
    stab = (attacker.pokedexes.element_type == skill.skill.element_type) ? 1.5 : 1
		type_multiplier = TYPE_CHART[skill.skill.element_type.to_sym][defender.pokedexes.element_type.to_sym]
		random_number = rand(85..100).to_d
		damage = ((2 * attacker.level / 5 + 2) * skill.skill.power * (attacker.attack / defender.defence) / 50 + 2) * stab * type_multiplier * (random_number / 100)
		damage.round
  end

  def self.calculate_experience(level:)
    rand(20..150) * level
  end

  def self.level_up(level_winner:, total_experience_winner:)
    experience_limit = level_winner * 200
    (total_experience_winner >= experience_limit) ? true : false
  end

  def self.calculate_level_up_extra_stats
		# result = ExtraStatsResult.new
		result.health_point = rand(10..20)
		result.attack = rand(1..5)
		result.defence = rand(1..5)
		result.speed = rand(1..5)
		result
	end

end