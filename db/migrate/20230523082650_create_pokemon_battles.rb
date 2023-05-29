class CreatePokemonBattles < ActiveRecord::Migration[6.1]
  def change
    create_table :pokemon_battles do |t|
      t.integer :pokemon1_id
      t.integer :pokemon2_id
      t.integer :current_turn, null: true, :default => nil
      t.string  :state,limit: 45
      t.integer :pokemon_winner_id, null: true, :default => nil
      t.integer :pokemon_loser_id, null: true, :default => nil
      t.integer :experience_gain, null: true, :default => nil
      t.integer :pokemon1_max_health_point, null: true, :default => nil
      t.integer :pokemon2_max_health_point, null: true, :default => nil

      t.timestamps
    end
    add_foreign_key :pokemon_battles, :pokemons, column: :pokemon1_id, primary_key: "id"
    add_foreign_key :pokemon_battles, :pokemons, column: :pokemon2_id, primary_key: "id"
    add_foreign_key :pokemon_battles, :pokemons, column: :pokemon_winner_id, primary_key: "id"
    add_foreign_key :pokemon_battles, :pokemons, column: :pokemon_loser_id, primary_key: "id"
  end

  def up
    change_column :pokemon_battles, :current_turn, :integer, :null => true, :default => nil
    change_column :pokemon_battles, :pokemon_winner_id, :integer, :null => true, :default => nil
    change_column :pokemon_battles, :pokemon_loser_id, :integer, :null => true, :default => nil
    change_column :pokemon_battles, :experience_gain, :integer, :null => true, :default => nil
    change_column :pokemon_battles, :pokemon1_max_health_point, :integer, :null => true, :default => nil
    change_column :pokemon_battles, :pokemon2_max_health_point, :integer, :null => true, :default => nil
  end

  def down
    change_column :pokemon_battles, :current_turn, :integer, :null => false, :default => nil
    change_column :pokemon_battles, :pokemon_winner_id, :integer, :null => false, :default => nil
    change_column :pokemon_battles, :pokemon_loser_id, :integer, :null => false, :default => nil
    change_column :pokemon_battles, :experience_gain, :integer, :null => false, :default => nil
    change_column :pokemon_battles, :pokemon1_max_health_point, :integer, :null => false, :default => nil
    change_column :pokemon_battles, :pokemon2_max_health_point, :integer, :null => false, :default => nil
  end

end
