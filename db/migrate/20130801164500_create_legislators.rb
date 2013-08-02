require_relative '../config'

class CreateLegislators < ActiveRecord::Migration
  def change
    create_table :legislators do |t|
      t.string :title
      t.string :firstname
      t.string :lastname
      t.date :birthdate
      t.string :state
      t.boolean :in_office
      t.string :phone
      t.string :fax
      t.string :twitter_id
      t.string :website
      t.string :webform
      t.string :party
    end
  end
end