class CreateBenefitsEcosystemServicesJoins < ActiveRecord::Migration[5.2]
  def change
    create_table :benefits_ecosystem_services_joins do |t|
      t.references :benefit, foreign_key: true
      t.references :ecosystem_service, foreign_key: true

      t.timestamps
    end
  end
end
