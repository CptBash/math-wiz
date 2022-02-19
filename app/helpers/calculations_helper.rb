module CalculationsHelper

  def generate_prime_numbers(start_value, end_value)
    solution = ""
    if start_value < end_value
      Prime.each(start_value..end_value) do |prime|
        solution << prime.to_s + ","
      end
    else
      Prime.each(end_value..start_value) do |prime|
        solution << prime.to_s + ","
      end
    end
    solution
  end

    def check_prime_number(solution)
      solution.strip(",").each do |value|
        for value.is_prime?
          true
        else
          false
        end
    end
  end
end
