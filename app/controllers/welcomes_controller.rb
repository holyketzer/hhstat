class WelcomesController < ApplicationController
  # GET /welcomes
  # GET /welcomes.json
  def index
    #@welcomes = Welcome.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_welcome
      @welcome = Welcome.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def welcome_params
      params[:welcome]
    end
end
