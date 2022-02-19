class AddDeletedAtToFormularies < ActiveRecord::Migration[7.0]
  def change
    add_column :formularies, :deleted_at, :datetime
    add_index :formularies, :deleted_at
  end
end
