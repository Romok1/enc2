# frozen_string_literal: true

module BiodiversityGoals
  module AgricultureDashboard
    class Dashboard
      include ActiveModel::Validations
      attr_accessor :forms

      AGRICULTURE_TYPES = %w[
        crops
        livestock
      ].freeze

      AREA_TYPES = %w[
        area
        turnover
      ].freeze

      validates_presence_of :forms
      validates_each :forms do |record, _attr, value|
        record.errors.add(:base, I18n.t("#{record.translation_path}.params")) unless value.none?(&:invalid?)
      end

      def initialize(form_data = [])
        @forms = form_data.each_with_index.map do |form, index|
          Form.new({ index: index, translation_path: translation_path }.merge(form))
        end
      end

      def errors_combined_with_nested_form_errors
        form_errors = @forms.each_with_index.each_with_object({}) do |(form, index), indexed_errors|
          indexed_errors[index.to_s] = form.errors.messages if form.errors.any?
        end
        all_errors = errors.to_hash
        all_errors[:forms] = form_errors unless form_errors.blank?
        all_errors
      end

      def indicators
        Calculator.calculate_indicators(to_hash[:agriculture_dashboard])
      end

      def self.alignment_options(
        current_user: nil,
        alignment_option_params: nil
      )
        AlignmentOptionsFilter.sorting(
          if alignment_option_params.present?
            AlignmentOptionsFilter.filtering(alignment_option_params)
          else
            AlignmentOption.agriculture
          end,
          current_user
        )
      end

      def self.alignment_option_filters(alignment_option_params)
        return alignment_option_params.except(:biodiversity_module) if alignment_option_params.present?

        {}
      end

      def to_hash
        {
          agriculture_dashboard: forms.map(&:to_hash)
        }
      end

      def translation_path
        case self.class.name.demodulize
        when 'Dashboard'
          'biodiversity_goals.validation.agriculture.manual_input'
        when 'CSV'
          'biodiversity_goals.validation.agriculture.csv'
        end
      end
    end
  end
end
