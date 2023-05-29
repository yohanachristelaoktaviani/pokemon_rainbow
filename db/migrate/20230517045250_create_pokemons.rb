class CreatePokemons < ActiveRecord::Migration[6.1]
  def change
    create_table :pokemons do |t|
      t.references :pokedex, null: false, foreign_key: {to_table: :pokedexes}
      t.string  :name, limit: 45, unique: true
      t.integer :level
      t.integer :max_health_point
      t.integer :current_health_point
      t.integer :attack
      t.integer :defence
      t.integer :speed
      t.integer :current_experience

      t.timestamps
    end
  end
end
