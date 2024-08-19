class CreateContacts < ActiveRecord::Migration[7.2]
  def change
    create_table :contacts do |t|
      t.references :user, foreign_key: true, null: false
      t.string :name, null: false
      t.string :cpf, null: false
      t.string :phone, null: false
      t.string :address, null: false
      t.float :latitude
      t.float :longitude
    end
  end
end
