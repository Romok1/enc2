# coding: utf-8
class UsersController < ApplicationController
  before_action :authenticate_user!

  def my_identity
    respond_to do |format|
      format.json do
        render json: current_user.as_json
      end
    end
  end
end
