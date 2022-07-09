class RenameAgriTypeColumnOnAgriIndicators < ActiveRecord::Migration[5.2]
  def change
    rename_column(:agri_indicators, :agri_type, :crop)
  end
end
