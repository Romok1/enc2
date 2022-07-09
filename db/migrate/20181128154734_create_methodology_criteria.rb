class CreateMethodologyCriteria < ActiveRecord::Migration[5.2]
  def change
    create_table :methodology_criteria do |t|
      t.bigint :table_id
      t.string :table_title
      t.string :criterion
      t.text :definition
      t.string :red
      t.string :amber
      t.string :green
      t.text :example
      t.text :use_case

      t.timestamps
    end
  end
end
