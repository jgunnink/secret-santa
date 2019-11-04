class HomeController < ApplicationController

  def index
  end

  def health_check
    render body: nil
  end

end
