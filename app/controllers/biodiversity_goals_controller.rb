# frozen_string_literal: true

class BiodiversityGoalsController < ApplicationController
  before_action :authenticate_user!

  def index
    @open_cards = I18n.t('biodiversity_goals.landing.open_cards').map.with_index do |card, index|
      {
        id: "dashboard_feature_#{index + 1}",
        title: card[:title],
        img_url: card[:img_url],
        content: card[:content]
      }
    end
  end
end
