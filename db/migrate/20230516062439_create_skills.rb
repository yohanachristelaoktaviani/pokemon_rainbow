class CreateSkills < ActiveRecord::Migration[6.1]
  def change
    create_table :skills do |t|
      t.string  :name, limit: 45, unique: true
      t.integer :power
      t.integer :max_pp
      t.string  :element_type, limit: 45

      t.timestamps
    end
  end
end
