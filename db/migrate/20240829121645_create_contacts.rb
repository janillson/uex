class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name
      t.string :cpf
      t.string :phone
      t.string :street
      t.string :number
      t.string :complement
      t.string :city_name
      t.string :state
      t.string :zipcode
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
