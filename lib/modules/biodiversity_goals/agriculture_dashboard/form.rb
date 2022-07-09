# frozen_string_literal: true

module BiodiversityGoals
  module AgricultureDashboard
    class Form
      MAX_VALUES = {
        area: 200_000_000, # 200 million ha
        turnover: 1e7 # 10 trillion => 10^7 million
      }.freeze

      include ActiveModel::Model
      include ActionView::Helpers::NumberHelper

      attr_accessor :country,
        :translation_path,
        :crops_value,
        :crops_area_type,
        :livestock_value,
        :livestock_area_type,
        :index

      validate :validate_country
      validates :crops_area_type, inclusion: {
        in: Dashboard::AREA_TYPES,
        message: lambda do |object, data|
                   I18n.t(
                     "#{object.translation_path}.invalid_area_type",
                     {
                       line_number: object.line_number,
                       value: data[:value]
                     }
                   )
                 end
      }, unless: -> { crops_value.blank? }
      validates :livestock_area_type, inclusion: {
        in: Dashboard::AREA_TYPES,
        message: lambda do |object, data|
                   I18n.t(
                     "#{object.translation_path}.invalid_area_type",
                     {
                       line_number: object.line_number,
                       value: data[:value]
                     }
                   )
                 end
      }, unless: -> { livestock_value.blank? }
      validate :validate_a_value_is_present
      validate :validate_values

      def validate_country
        if country.blank?
          errors.add(:country, I18n.t("#{translation_path}.country.empty", { line_number: line_number }))
        elsif !Country.with_agriculture_countries.where(iso_3: country).exists?
          add_not_found_country_error
        end
      end

      def add_not_found_country_error
        translation = I18n.t(
          "#{translation_path}.country.not_found", { line_number: line_number, value: country }
        )
        errors.add(:country, translation)
      end

      def validate_a_value_is_present
        return unless crops_value.blank? && livestock_value.blank?

        errors.add(:base, I18n.t("#{translation_path}.area.empty", { line_number: line_number }))
      end

      def validate_values
        Dashboard::AGRICULTURE_TYPES.each do |crop_type|
          validate_value(crop_type)
        end
      end

      def validate_value(crop_type)
        value = send("#{crop_type}_value")
        area_type = send("#{crop_type}_area_type")
        return if value.blank?
        return unless Dashboard::AREA_TYPES.include?(area_type)

        if value_a_number?(value)
          add_invalid_range_error(crop_type, area_type) unless value_within_acceptable_range?(area_type, value)
        else
          add_invalid_number_error(crop_type)
        end
      end

      def value_a_number?(value)
        (value.to_f.to_s == value.to_s || value.to_i.to_s == value.to_s) && value.to_f > 0.0
      end

      def max_value(area_type)
        MAX_VALUES[area_type.to_sym].to_f
      end

      def value_within_acceptable_range?(area_type, value)
        value.to_f <= max_value(area_type)
      end

      def add_invalid_range_error(crop_type, area_type)
        translation = I18n.t(
          "#{translation_path}.area.range",
          {
            attribute: I18n.t("biodiversity_goals.validation.agriculture.attributes.#{crop_type}"),
            line_number: line_number,
            value: number_to_human(max_value(area_type))
          }
        )
        errors.add(crop_type, translation)
      end

      def add_invalid_number_error(crop_type)
        translation = I18n.t(
          "#{translation_path}.area.not_a_number",
          {
            attribute: I18n.t("biodiversity_goals.validation.agriculture.attributes.#{crop_type}"),
            line_number: line_number
          }
        )
        errors.add(crop_type, translation)
      end

      def line_number
        index.to_i + 2 # count from 1 and include headers row
      end

      def to_hash
        {
          country: country,
          crops_value: crops_value,
          crops_area_type: crops_area_type,
          livestock_value: livestock_value,
          livestock_area_type: livestock_area_type
        }
      end
    end
  end
end
