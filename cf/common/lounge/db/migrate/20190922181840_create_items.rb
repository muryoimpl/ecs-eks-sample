class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name, null: false, index: true
      t.text :memo

      t.timestamps
    end
  end
end
