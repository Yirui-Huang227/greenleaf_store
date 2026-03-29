class AboutController < ApplicationController
  def index
    @about_page = AboutPage.first
  end
end
