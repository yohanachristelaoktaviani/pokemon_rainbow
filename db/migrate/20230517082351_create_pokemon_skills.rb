class CreatePokemonSkills < ActiveRecord::Migration[6.1]
  def change
    create_table   :pokemon_skills do |t|
      t.references :pokemon, null: false, foreign_key: {to_table: :pokemons}
      t.references :skill, null: true, :default => nil, foreign_key: {to_table: :skills}
      t.integer    :current_pp

      t.timestamps
    end

  def up
    change_column :pokemon_skills, :skill_id, :integer, :null => true, :default => nil
  end

  def down
    change_column :pokemon_skills, :skill_id, :integer, :null => false, :default => nil
  end
  end
end
