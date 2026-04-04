class ContactController < ApplicationController
  def show
    @about_page = AboutPage.last
  end
end
