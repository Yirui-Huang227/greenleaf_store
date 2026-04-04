class AboutController < ApplicationController
  def index
    @about_page = AboutPage.last
  end
end
