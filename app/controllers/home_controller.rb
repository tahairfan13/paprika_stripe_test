class HomeController < ApplicationController
  def index
    render json: { message: 'Welcome to paprika stripe test' }, status: :ok
  end
end
