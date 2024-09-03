class CreateTestTemplate < ActiveRecord::Migration[7.1]
  def change
    create_table :test_template do |t|
      t.string :python
      t.string :java
      t.string :cpp
      t.references :challenge, null: false, foreign_key: true
      t.timestamps
    end
  end
end
