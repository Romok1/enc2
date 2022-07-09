# frozen_string_literal: true

module BiodiversityGoals
  module MiningDashboard
    class Dashboard
      include ActiveModel::Validations
      attr_accessor :forms

      MINIMUM_COMPANIES = 2

      validates_presence_of :forms
      validates_each :forms do |record, _attr, value|
        next if value.none?(&:invalid?)

        record.errors.add(:base, I18n.t("#{record.translation_path}.params"))
      end

      validate :validate_whole_sector_absent_in_multi_form_submission, if: lambda { |dashboard|
        dashboard.forms.length > 1
      }

      validate :validate_minimum_companies, unless: lambda { |dashboard|
        dashboard.forms[0].whole_sector_selected?
      }

      validate :validate_no_duplicate_companies

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

      def count_mines
        Indicators.count_mines(to_hash[:mining_dashboard])
      end

      def indicators
        Calculator.calculate_indicators(to_hash[:mining_dashboard], ecoregions)
      end

      def self.alignment_options(
        current_user: nil,
        alignment_option_params: nil
      )
        AlignmentOptionsFilter.sorting(
          if alignment_option_params.present?
            AlignmentOptionsFilter.filtering(alignment_option_params)
          else
            AlignmentOption.mining
          end,
          current_user
        )
      end

      def self.alignment_option_filters(alignment_option_params)
        return {} unless alignment_option_params.present?

        alignment_option_params.except(:biodiversity_module)
      end

      def validate_whole_sector_absent_in_multi_form_submission
        return unless forms.length > 1 && forms[0].whole_sector_selected?

        errors.delete(:base)
        errors.add(:base, I18n.t("#{translation_path}.whole_sector_cannot_be_mixed"))
      end

      def validate_minimum_companies
        return if forms.length >= MINIMUM_COMPANIES

        errors.add(:base, I18n.t("#{translation_path}.minimum_forms"))
      end

      def validate_no_duplicate_companies
        return if forms.count == forms.group_by(&:company_id).count

        errors.add(:base, I18n.t("#{translation_path}.no_duplicate_companies"))
      end

      def to_hash
        {
          mining_dashboard: forms.map(&:to_hash)
        }
      end

      def translation_path
        case self.class.name.demodulize
        when 'Dashboard'
          'biodiversity_goals.validation.mining.manual_input'
        when 'CSV'
          'biodiversity_goals.validation.mining.csv'
        end
      end

      def ecoregions
        forms.flat_map do |form|
          return [] if form.company_id.blank?

          query = Ecoregion.eager_load(mine_indicators: [:country, { mines_companies_joins: :company }])
            .where('companies.id': form.company_id)
          query = query.where('countries.iso_3': form.locations) if form.locations.present?
          query
        end
      end
    end
  end
end
