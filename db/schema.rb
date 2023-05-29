# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_05_29_075910) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pokedexes", force: :cascade do |t|
    t.string "name", limit: 45
    t.integer "base_health_point"
    t.integer "base_attack"
    t.integer "base_defence"
    t.integer "base_speed"
    t.string "element_type", limit: 45
    t.string "image_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "pokedex_name", unique: true
  end

  create_table "pokemon_battles", force: :cascade do |t|
    t.integer "pokemon1_id"
    t.integer "pokemon2_id"
    t.integer "current_turn"
    t.string "state", limit: 45
    t.integer "pokemon_winner_id"
    t.integer "pokemon_loser_id"
    t.integer "experience_gain"
    t.integer "pokemon1_max_health_point"
    t.integer "pokemon2_max_health_point"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pokemon_evolutions", force: :cascade do |t|
    t.string "pokedex_from_name"
    t.string "pokedex_to_name"
    t.integer "minimum_level"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pokemon_skills", force: :cascade do |t|
    t.bigint "pokemon_id", null: false
    t.bigint "skill_id"
    t.integer "current_pp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pokemon_id"], name: "index_pokemon_skills_on_pokemon_id"
    t.index ["skill_id"], name: "index_pokemon_skills_on_skill_id"
  end

  create_table "pokemons", force: :cascade do |t|
    t.bigint "pokedex_id", null: false
    t.string "name", limit: 45
    t.integer "level"
    t.integer "max_health_point"
    t.integer "current_health_point"
    t.integer "attack"
    t.integer "defence"
    t.integer "speed"
    t.integer "current_experience"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pokedex_id"], name: "index_pokemons_on_pokedex_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name", limit: 45
    t.integer "power"
    t.integer "max_pp"
    t.string "element_type", limit: 45
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "skill_name", unique: true
  end

  add_foreign_key "pokemon_battles", "pokemons", column: "pokemon1_id"
  add_foreign_key "pokemon_battles", "pokemons", column: "pokemon2_id"
  add_foreign_key "pokemon_battles", "pokemons", column: "pokemon_loser_id"
  add_foreign_key "pokemon_battles", "pokemons", column: "pokemon_winner_id"
  add_foreign_key "pokemon_skills", "pokemons"
  add_foreign_key "pokemon_skills", "skills"
  add_foreign_key "pokemons", "pokedexes"
end
