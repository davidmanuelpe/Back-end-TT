class CreateFormularies < ActiveRecord::Migration[7.0]
  def change
    create_table :formularies do |t|
      t.string :nome

      t.timestamps
    end
  end
end
