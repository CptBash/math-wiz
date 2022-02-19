require 'byebug'
class CalculationsController < ApplicationController

  def index
    @calculations = Calculation.all
  end

  def create
    calculation_params.delete("controller")
    calculation_params.delete("action")
    @calculation = Calculation.create(calculation_params)
    if @calculation[:calculation_type] == "generate_prime"
      @calculation[:solution] = {answer: helpers.generate_prime_numbers(@calculation[:start_value], @calculation[:end_value])}
      @calculation[:is_prime] = check_prime_number(@calculation[:solution][:answer])
    else
      @calculation[:solution] = "unsupported calculation"
    end
  end

  def show
    @calculation = Calculation.find(params[:id])
  end

  private
    def calculation_params
      #TODO figure out why strong params is returning as a string
      # params.require(:calculation_type).permit(:start_value, :end_value, :solution, :error)
      params.permit!()
    end

end
