class PokemonsController < ApplicationController
  before_action :set_pokemon, only: [:edit, :update, :show, :destroyskill]

  add_breadcrumb "Home", :root_path, :options => { :title => "Home" }
  add_breadcrumb "Pokemons Index", :pokemons_path


  def index
    @pokemons = Pokemon.page(params[:page]).per(50)
  end

  def new
    @pokemon = Pokemon.new
    @pokedex = Pokedex.order('id ASC')
    add_breadcrumb "New Pokemon", :new_pokemon_path
  end

  def create
    @pokemon = Pokemon.new(pokemon_params)

    @pokemon.name = @pokemon.pokedexes.name
    @pokemon.max_health_point = @pokemon.pokedexes.base_health_point
    @pokemon.current_health_point = @pokemon.pokedexes.base_health_point
    @pokemon.attack = @pokemon.pokedexes.base_attack
    @pokemon.defence = @pokemon.pokedexes.base_defence
    @pokemon.speed = @pokemon.pokedexes.base_speed
    @pokemon.current_experience = 0
    @pokemon.level = 1


    if @pokemon.save
      flash[:success] = "Pokemon was successfully created"
      redirect_to pokemons_path(@pokemon)
    else
      # puts 'ERROR ', @pokemon.errors.full_messages
      # flash[:danger] = @pokemon.errors.full_messages
      redirect_to pokemons_path
    end
  end

  def edit
    @pokemon = Pokemon.find(params[:id])
    # @pokemon_json = @pokemon.to_json
    # render json: @pokemon_json

    @pokemon_skill = @pokemon.pokemon_skills.limit(4)
    @skills = Skill.all
    # @skills = Skill.joins(:element_type).where(element_type: { name: @pokemon.element_type })
    @pokemon.pokemon_skills.build
    add_breadcrumb "Edit Pokemon and Skill", :edit_pokemon_path

    # @selected_skill = [0,2,4]


    # render json: @pokemon.to_json(include: :pokemon_skills)
    respond_to do |format|
      format.html
      # format.json { render json: @pokemon.to_json(include: :pokemon_skills) }
      format.json { render json: { pokemon: @pokemon, pokemon_skills: @pokemon_skill, selected_skill: @selected_skill } }
    end
  end

  def update
    @pokemons = Pokemon.find(params[:id])

    if params[:pokemon][:current_health_point].to_i > params[:pokemon][:max_health_point].to_i
      flash[:danger] = 'Current HP cannot be greater than Maximum HP.'
      redirect_to edit_pokemon_path(@pokemon)
      return
    end

    updated_skills_attributes = pokemon_params[:pokemon_skills_attributes]
    if updated_skills_attributes
      updated_skills_attributes.each do |index, skill_attributes|
        if skill_attributes[:skill_id].present?
          skill_id = skill_attributes[:skill_id].to_i
          current_pp = skill_attributes[:current_pp].to_i
          max_pp = Skill.find(skill_id).max_pp.to_i

          if current_pp > max_pp
            flash[:danger] = 'Current PP cannot be greater than Maximum PP for a skill.'
            redirect_to edit_pokemon_path(@pokemon)
            return
          end
        end
      end

      @pokemon.pokemon_skills.destroy_all
      updated_skills_attributes.each do |index, skill_attributes|
        if skill_attributes[:skill_id].present?
          @pokemon.pokemon_skills.build(skill_attributes)
        end
      end
    end

    if @pokemon.update(pokemon_params.except(:pokemon_skills_attributes))
      redirect_to @pokemon
      flash[:success] = 'Pokemon updated successfully.'
    else
      render :edit
    end
  end


  def show

    @pokemons = Pokemon.find(params[:id])
    # render json: @pokemon.to_json(include: :pokemon_skills)
    respond_to do |format|
      format.html
      format.json { render json: @pokemon.to_json(include: :pokemon_skills) }
    end

    add_breadcrumb "Detail pokemon", :pokemon_path
  end

  def destroy
    @pokemons = Pokemon.find_by(id: params[:id])
    if @pokemons.destroy
      flash[:danger] = "Pokemons was successfully deleted"
      redirect_to pokemons_path(@pokemons)
      else
      puts 'ERROR ', @pokemons.errors.full_messages
      flash[:danger] = @pokemons.errors.full_messages
      redirect_to pokemons_path
    end
  end

  def destroyskill
    # @pokemons = Pokemon.find(params[:id])
    @pokemon_skill = PokemonSkill.find_by(id: params[:id])
    @pokemon.pokemon_skills.destroy
    flash[:danger] = 'Skill removed successfully'
    redirect_to pokemon_path
    # pokemon edit
    # end
  end

  def heal
    @pokemons = Pokemon.all
    @pokemons.each do |pokemon|
      pokemon.pokemon_skills.each do |skill|
      pokemon.current_health_point = pokemon.max_health_point
      skill.current_pp = skill.skill.max_pp
      skill.save
      pokemon.save
    end
  end
    redirect_to pokemons_path
  end

  def healer
    @pokemons = Pokemon.find(params[:id])
    @pokemon_skills = PokemonSkill.find_by(id: params[:id])
    @pokemons.pokemon_skills.each do |skill|
      @pokemons.current_health_point = @pokemons.max_health_point
      skill.current_pp = skill.skill.max_pp
      @pokemons.save
      skill.save
    end
    redirect_to pokemons_path
  end

  def healshow
    @pokemons = Pokemon.find(params[:id])
    @pokemons.current_health_point = @pokemons.max_health_point
    # @pokemons.pokemon_skills.current_pp = @pokemons.skills.max_pp
    @pokemons.save
    redirect_to pokemon_path
  end

  private
  def pokemon_params
    params.require(:pokemon).permit(:pokedex_id, :name, :max_health_point, :current_health_point, :attack, :defence, :speed, :current_experience, :level, :pokemon_skill_id, pokemon_skills_attributes: [:skill_id, :current_pp])
  end

  def pokemon_skill_params
    params.require(:pokemon).require(:skill).permit(:skill_id)
  end

  def set_pokemon
    @pokemon = Pokemon.find(params[:id])
  end

end
