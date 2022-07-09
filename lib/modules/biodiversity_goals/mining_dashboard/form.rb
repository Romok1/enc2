# frozen_string_literal: true

module BiodiversityGoals
  module MiningDashboard
    class Form
      include ActiveModel::Model
      attr_accessor :company_id,
        :translation_path,
        :locations,
        :index

      validate :validate_company_present, unless: ->(form) { form.inital_form_and_whole_sector_selected? }
      validate :validate_company_exists, if: ->(form) { form.company_id.present? }
      validate :validate_every_country_exists, if: ->(form) { form.locations.present? }

      def initialize(attributes = {})
        raise 'Index must be present' unless attributes[:index].present? # we also expect locations and company_id

        super
      end

      def line_number
        index.to_i + 2 # count from 1 and include headers row
      end

      def company_name=(company_name)
        id = Company.select(:id).where(name: company_name).pluck(:id).first
        if id
          @company_id = id
        else
          translation = I18n.t(
            "#{translation_path}.company.not_found", { line_number: line_number, value: company_name }
          )
          errors.add(:company_id, translation)
        end
      end

      def inital_form_and_whole_sector_selected?
        index.zero? && whole_sector_selected?
      end

      def whole_sector_selected?
        company_id.blank? && locations.blank?
      end

      def validate_company_present
        return unless company_id.blank?

        translation = I18n.t("#{translation_path}.company.empty", { line_number: line_number })
        errors.add(:company_id, translation)
      end

      def validate_company_exists
        return if Company.where(id: company_id).exists?

        errors.add(:company_id, I18n.t("#{translation_path}.company.not_found", { line_number: line_number }))
      end

      def missing_countries
        locations - Country.select(:iso_3).where(iso_3: locations).pluck(:iso_3)
      end

      def validate_every_country_exists
        return if missing_countries.empty?

        translation = I18n.t(
          "#{translation_path}.countries.not_found",
          { line_number: line_number, value: missing_countries.join(', ') }
        )
        errors.add(:locations, translation)
      end

      def to_hash
        {
          company_id: company_id,
          locations: locations.is_a?(Array) ? locations : []
        }
      end
    end
  end
end
