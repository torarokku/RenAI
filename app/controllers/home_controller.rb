class HomeController < ApplicationController
  def index
    @partners = Partner.all

    @badges = UserBadge.where(
      user: current_user
    )
  end
end
