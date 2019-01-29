class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :value
      t.integer :post_id, index: true

      t.timestamps
    end
  end
end
