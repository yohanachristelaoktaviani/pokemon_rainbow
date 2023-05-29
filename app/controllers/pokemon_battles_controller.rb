require '/home/yohanachristelaoktaviani/pokemon_rainbow/lib/pokemon_battle_calculator.rb'

class PokemonBattlesController < ApplicationController

  add_breadcrumb "Home", :root_path, :options => { :title => "Home" }
  add_breadcrumb "Pokemon Battle Index", :pokemon_battles_path

  def index
    @pokemon_battles = PokemonBattle.order('id DESC').page(params[:page]).per(20)
    @pokemons = Pokemon.all
  end

  def new
    @pokemons = Pokemon.where.not(current_health_point: 0)
    @pokemon_battle = PokemonBattle.new

    add_breadcrumb "New Battle", :new_pokemon_battle_path

    # @pokemon_battle = PokemonBattle.includes(:pokemon).where.not(current_health_point: 0)
  end

  def create
    @pokemon_battle = PokemonBattle.new(pokemon_battle_params)
    # @pokemon_battle.pokemon1.current_health_point = @pokemon_battle.pokemon1_max_health_point
    # @pokemon_battle.pokemon2.current_health_point = @pokemon_battle.pokemon2_max_health_point

    @pokemon_battle.current_turn = 1
    @pokemon_battle.state = "ongoing"

    if @pokemon_battle.valid?
        @pokemon_battle.pokemon1.save
        @pokemon_battle.pokemon2.save
        @pokemon_battle.save
        redirect_to pokemon_battle_path(@pokemon_battle)

    else
      # puts 'ERROR ', @pokemon_battle.errors.full_messages
      flash[:danger] = @pokemon_battle.errors.full_messages
      # redirect_to puts 'ERROR ', @battle.errors.full_messages
      # flash[:danger] = @battle.errors.full_messages
      redirect_to new_pokemon_battle_path
    end

  end

  def show
    @pokemon_battle = PokemonBattle.find_by(id: params[:id])

    @pokemon1_skill = PokemonSkill.includes(:skill).where(pokemon_id: @pokemon_battle.pokemon1_id).where.not(current_pp: 0)
    @pokemon2_skill = PokemonSkill.includes(:skill).where(pokemon_id: @pokemon_battle.pokemon2_id).where.not(current_pp: 0)

    # binding.pry
    @pokemon1_attack = @pokemon1_skill.map{ |ps| ["#{ps.skill.name} (#{ps.current_pp} / #{ps.skill.max_pp})", ps.id] }
    @pokemon2_attack = @pokemon2_skill.map{ |ps| ["#{ps.skill.name} (#{ps.current_pp} / #{ps.skill.max_pp})", ps.id] }

    add_breadcrumb "Show", :pokemon_battle_path
  end

  def calculate_exp1
    level = @pokemon_battle.pokemon2.level
    @exp = PokemonBattleCalculator.calculate_experience(level:level)
    @pokemon_battle.experience_gain = @pokemon_battle.pokemon1.current_experience + @exp
    @pokemon_battle.pokemon1.current_experience = @pokemon_battle.experience_gain
  end

  def calculate_exp2
    level = @pokemon_battle.pokemon1.level
    @exp = PokemonBattleCalculator.calculate_experience(level:level)
    @pokemon_battle.experience_gain = @pokemon_battle.pokemon2.current_experience + @exp
    @pokemon_battle.pokemon2.current_experience = @pokemon_battle.experience_gain
  end

  def attack
    @pokemon_battle = PokemonBattle.find_by(id: params[:id])

    # @pokemon_battle.current_turn = PokemonBattle.maximum(:current_turn) || 0
    # @pokemon_battle.current_turn = @pokemon_battle.current_turn + 1
    attacker, defender = @pokemon_battle.current_turn.even? ? [@pokemon_battle.pokemon2, @pokemon_battle.pokemon1] : [@pokemon_battle.pokemon1, @pokemon_battle.pokemon2]

    if @pokemon_battle.current_turn.odd?
      skill = PokemonSkill.find(params[:skill1_id])
      pokemon_skill = @pokemon_battle.pokemon1.pokemon_skills.find_by(skill_id: skill.skill_id)   #hitung pp

      @damage = PokemonBattleCalculator.calculate_damage(attacker:attacker, defender:defender, skill:skill)
      @pokemon_battle.pokemon2.current_health_point = @pokemon_battle.pokemon2.current_health_point - @damage

      if @pokemon_battle.pokemon2.current_health_point <=0
        pokemon1_win
      end

    elsif @pokemon_battle.current_turn.even?
      skill = PokemonSkill.find(params[:skill2_id])
      pokemon_skill = @pokemon_battle.pokemon2.pokemon_skills.find_by(skill_id: skill.skill_id)   #hitung pp

      @damage = PokemonBattleCalculator.calculate_damage(attacker:attacker, defender:defender, skill:skill)
      @pokemon_battle.pokemon1.current_health_point = @pokemon_battle.pokemon1.current_health_point - @damage

      if @pokemon_battle.pokemon1.current_health_point <=0
        pokemon2_win
      end

    end

    pokemon_skill.current_pp = pokemon_skill.current_pp - 1
    if pokemon_skill.current_pp < 0
      pokemon_skill.current_pp = 0
    end
    pokemon_skill.save
    @pokemon_battle.current_turn += 1

    @pokemon_battle.pokemon1.save
    @pokemon_battle.pokemon2.save
    @pokemon_battle.save
    redirect_to pokemon_battle_path
  end

  def pokemon1_win
    @pokemon_battle = PokemonBattle.find_by(id: params[:id])

    @pokemon_battle.pokemon2.current_health_point = 0
    flash[:notice] = "Pokemon 1 Win!"
    @pokemon_battle.winner = @pokemon_battle.pokemon1
    @pokemon_battle.loser = @pokemon_battle.pokemon2
    @pokemon_battle.state = "finish"
    @pokemon_battle.pokemon1_max_health_point =   @pokemon_battle.pokemon1.current_health_point
    @pokemon_battle.pokemon2_max_health_point =   @pokemon_battle.pokemon2.current_health_point

    calculate_exp1
    level_up1
  end

  def pokemon2_win
    @pokemon_battle = PokemonBattle.find_by(id: params[:id])

    @pokemon_battle.pokemon1.current_health_point = 0
    flash[:notice] = "Pokemon 2 Win!"
    @pokemon_battle.winner = @pokemon_battle.pokemon2
    @pokemon_battle.loser = @pokemon_battle.pokemon1
    @pokemon_battle.state = "finish"
    @pokemon_battle.pokemon1_max_health_point = @pokemon_battle.pokemon1.current_health_point
    @pokemon_battle.pokemon2_max_health_point = @pokemon_battle.pokemon2.current_health_point

    calculate_exp2
    level_up2
  end

  def surrender1
    pokemon2_win
    redirect_to pokemon_battle_path
  end

  def surrender2
    pokemon1_win
    redirect_to pokemon_battle_path
  end

  def level_up1
    @lvl = false
    level_winner = @pokemon_battle.pokemon1.level
    total_experience_winner =  @pokemon_battle.pokemon1.current_experience
    while @lvl == false
    # binding.pry
    @pokemon1_levelup = PokemonBattleCalculator.level_up(level_winner:level_winner, total_experience_winner:total_experience_winner)
      if @pokemon1_levelup == true
        level_winner = level_winner + 1

      elsif @pokemon1_levelup == false
        @lvl = true
      end
    end
    @pokemon_battle.pokemon1.level = level_winner
    @pokemon_battle.save
  end

  def level_up2
    @lvl = false
    level_winner = @pokemon_battle.pokemon2.level
    total_experience_winner =  @pokemon_battle.pokemon2.current_experience
    while @lvl == false
    # binding.pry
    @pokemon2_levelup = PokemonBattleCalculator.level_up(level_winner:level_winner, total_experience_winner:total_experience_winner)
      if @pokemon2_levelup == true
        level_winner = level_winner + 1

      elsif @pokemon2_levelup == false
        @lvl = true
      end
    end
    @pokemon_battle.pokemon2.level = level_winner
    @pokemon_battle.save
  end

  private
  def pokemon_battle_params
   params.require(:pokemon_battle).permit(:pokemon1_id, :pokemon2_id, :pokemon_winner_id, :pokemon_loser_id, :current_turn, :selected_battle)
  end


end
