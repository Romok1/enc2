class SubIndustriesController < ApplicationController
  def index
    @sub_industries = SubIndustry.all.sort_by{ |sub_industry| sub_industry.name }

    respond_to do |format|
      format.html {}
      format.json { render json: @sub_industries.map(&:to_formatted_json) }
    end
  end
end
