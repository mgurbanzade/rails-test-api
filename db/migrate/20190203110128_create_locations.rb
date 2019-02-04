class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :ip, unique: true

      t.timestamps
    end

    add_column :posts, :location_id, :integer
    add_index :posts, :location_id
  end
end
