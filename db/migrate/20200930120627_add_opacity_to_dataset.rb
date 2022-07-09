class AddOpacityToDataset < ActiveRecord::Migration[5.2]
  def change
    add_column :datasets, :opacity, :float
  end
end
