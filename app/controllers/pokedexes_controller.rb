class PokedexesController < ApplicationController
  add_breadcrumb "Home", :root_path, :options => { :title => "Home" }
  add_breadcrumb "Pokedexes", :pokedexes_path

  def index
    @pokedexes = Pokedex.order('name ASC').page(params[:page]).per(50)
  end

  def show
    @pokedexes = Pokedex.find(params[:id])
    add_breadcrumb "Detail Pokedexes", :pokedex_path
  end

  def search
    if params[:search_by_name] && params[:search_by_name] != ""
      @pokedexes = Pokedex.where("lower(name) LIKE ?","%#{params[:search_by_name]}%")
    end
  end

end
