class CreateCodeTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :code_templates do |t|
      t.string :python
      t.string :java
      t.string :cpp
      t.references :challenge, null: false, foreign_key: true
      t.timestamps
    end
  end
end
