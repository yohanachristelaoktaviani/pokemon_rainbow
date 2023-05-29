class CreatePokemonEvolutions < ActiveRecord::Migration[6.1]
  def change
    create_table :pokemon_evolutions do |t|
      t.string  :pokedex_from_name
      t.string  :pokedex_to_name
      t.integer :minimum_level

      t.timestamps
    end
  end
end
