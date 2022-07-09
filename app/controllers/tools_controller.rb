class ToolsController < ApplicationController
  before_action :authenticate_user!

  def index
    @link_tiles_top = I18n.t('tools.link_tiles_top.tiles')
    @link_tiles_bottom = I18n.t('tools.link_tiles_bottom.tiles')
  end
end
