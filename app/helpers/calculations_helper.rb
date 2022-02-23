module CalculationsHelper
  def generate_prime_numbers(start_value, end_value)
    prime_numbers_array = []
    if (start_value < end_value)
      ((start_value)..(end_value)).to_a.each do |prime|
        if prime.prime?
          prime_numbers_array << prime
        end
      end
    else
      ((end_value)..(start_value)).to_a.each do |prime|
        if prime.prime?
          prime_numbers_array << prime
        end
      end
    end
    prime_numbers_array
  end
end
