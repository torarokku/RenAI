class HomeController < ApplicationController
  def index
    @partners = Partner.all
  end
end
