class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.String :name

      t.timestamps
    end
  end
end
