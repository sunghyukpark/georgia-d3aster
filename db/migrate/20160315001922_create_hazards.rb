class CreateHazards < ActiveRecord::Migration
  def change
    create_table :hazards do |t|
      t.string :name
      t.string :type
      t.string :postal_code
      t.integer :injuries
      t.integer :fatalities
      t.integer :property_damage
      t.integer :crop_damage
      t.integer :hazard_id
      t.integer :fips_code
      t.datetime :begin_date
      t.datetime :end_date

      t.timestamps null: false
    end
  end
end
