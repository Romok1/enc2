class AddNameAndOrganisationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :text
    add_column :users, :organisation, :text
  end
end
