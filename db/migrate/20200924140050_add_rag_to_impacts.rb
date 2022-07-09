class AddRagToImpacts < ActiveRecord::Migration[5.2]
  def change
    add_column :impacts, :rag, :string
  end
end
