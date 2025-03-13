class CreateHistImplAcomps < ActiveRecord::Migration
  def change
    create_table :hist_impl_acomp do |t|
      t.integer :impl_id
      t.integer :acomp_id
      t.string :tipo

      t.timestamps null: false
    end
    remove_column :activities, :anterior, :boolean
  end
end
