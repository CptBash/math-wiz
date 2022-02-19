class CalculationsController < ActionController::API
  def index
    @calculations = Calculation.all
  end

  def create
    @calculation = Calculation.create(calculation_params)
    if @calculation[:calculation_type] == "generate_prime"
      @calculation[:solution] = {answer: generate_prime_number(@calculation[:options])}
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
      params.require(:calculation_type).permit(start_value:integer, end_value:integer, :solution, :error)
    end

end
