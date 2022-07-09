class AddSourceLayerToDatasets < ActiveRecord::Migration[5.2]
  def change
    add_column :datasets, :source_layer, :string
  end
end
