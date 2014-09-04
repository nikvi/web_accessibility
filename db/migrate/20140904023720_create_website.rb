class CreateWebsite < ActiveRecord::Migration
  def change
  	 create_table :website do |t|
      t.string :url
      t.string :name
 
      t.timestamps
    end
  end
end
