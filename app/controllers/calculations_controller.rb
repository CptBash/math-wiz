class CalculationsController < ApplicationController

  def index
    @calculations = Calculation.all
    render json: @calculations
  end

  def create
    calculation_params.delete("controller")
    calculation_params.delete("action")
    @calculation = Calculation.create(calculation_params)
    if @calculation[:start_value] == nil or @calculation[:end_value] == nil
      @calculation[:error] = "Unsupported start value or end value"
    else
      if @calculation[:calculation_type] == "generate_prime"
        @calculation[:solution] = { answer: helpers.generate_prime_numbers(@calculation[:start_value], @calculation[:end_value]) }
        if @calculation[:solution][:answer].empty?
          @calculation[:error] = "No prime numbers generated"
        end
      else
        @calculation[:error] = "unsupported calculation"
      end
    end

    render json: @calculation
  end

  def show
    @calculation = Calculation.find(params[:id])
    render json: @calculation
  rescue StandardError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  def destroy
    @calculation = Calculation.find(params[:id])
    @calculation.destroy
  end

  private
    def calculation_params
      #TODO figure out why strong params is returning as a string
      # params.require(:calculation_type).permit(:start_value, :end_value, :solution, :error)
      params.permit!()
    end

end
