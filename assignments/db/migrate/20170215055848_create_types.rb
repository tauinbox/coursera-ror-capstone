class CreateTypes < ActiveRecord::Migration
  def change
    create_table :types do |t|
      t.references :thing, index: true, foreign_key: true
      t.string :tags, array: true, default: []

      t.timestamps null: false
    end
  end
end
