class AddAgreedToContactForNewFunctionalityUpdatesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :agreed_to_contact_for_new_functionality_updates, :boolean, default: false
  end
end
