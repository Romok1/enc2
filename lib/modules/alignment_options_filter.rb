class AlignmentOptionsFilter
  attr_reader :params

  def self.filtering(params)
    new(params).filtering
  end

  def initialize(params)
    @params = params
  end

  def filtering
    options = AlignmentOption.all.public_send(params[:biodiversity_module])
    options = options.where(engagement_depth: (params[:engagement_depth].map { |a| a.humanize } << 'Both')) if params[:engagement_depth]
    options = options.where(engagement_scope: (params[:engagement_scope].map { |a| a.humanize } << 'Both')) if params[:engagement_scope]
    options = options.where(sbtn_step: params[:sbtn_step].map { |a| a.humanize }) if params[:sbtn_step]
    options = options.where(future_scenario: (params[:future_scenario].map { |a| a.humanize } << 'Both')) if params[:future_scenario]
    options = options.where(biodiversity_metric: (params[:biodiversity_metric].map { |a| a.humanize } << 'Both')) if params[:biodiversity_metric]
    options = options.where('mitigation_hierarchy ~* ?', "#{params[:mitigation_hierarchy].join('|')}") if params[:mitigation_hierarchy]
    options
  end

  def self.sorting(options, user)
    options =
      if user.organisation_type.alignment_options_organisation_types_joins.empty?
        options.order(:sbtn_step_order)
                .select(:id, :principle, :description, :resource, :sbtn_step_order)
                .uniq
      else
        options.joins(:alignment_options_organisation_types_joins)
                .order('alignment_options_organisation_types_joins.priority', :sbtn_step_order)
                .select('alignment_options.id', :principle, :description, :resource, 'alignment_options_organisation_types_joins.priority', :sbtn_step_order)
                .uniq

      end
    options
  end
end
