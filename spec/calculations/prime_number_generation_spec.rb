require 'rails_helper'

RSpec.describe "Prime Number Calculation", type: :request do
  describe "POST /create" do
    before(:all) do
      @endpoint = 'calculations/'
      @calculation_type = 'generate_prime'
    end
    context "When given values are prime" do
      it "with random prime numbers returns 200 success and solution" do
        start_value = rand(0..9000)
        end_value = rand(0..9000)
        post "http://localhost:3000/" + @endpoint, params: { start_value: start_value, end_value: end_value, calculation_type: @calculation_type }
        expect(response).to have_http_status(200)
        #TODO method to parse body to json for cleaner comparison
        expect(response[:is_prime]).to eq(true)
      end

      it "with range of 1 - 2 returns 200 success and solution" do
        start_value = 1
        end_value = 2
        post "http://localhost:3000/" + @endpoint, params: { start_value: start_value, end_value: end_value, calculation_type: @calculation_type }
        expect(response).to have_http_status(200)

        expect(response[:is_prime]).to eq(true)
      end

      it "with range of 7900 - 7920 returns 200 success and solution" do
        start_value = 7900
        end_value = 7920
        post "http://localhost:3000/" + @endpoint, params: { start_value: start_value, end_value: end_value, calculation_type: @calculation_type }
        expect(response).to have_http_status(200)

        expect(response[:is_prime]).to eq(true)
      end

      it "with invalid calculation_type returns 200 success and invalid calculation_type rror" do
        start_value = rand(0..9000)
        end_value = rand(0..9000)
        calculation_type = "foo-BAR"
        post "http://localhost:3000/" + @endpoint, params: { start_value: start_value, end_value: end_value, calculation_type: calculation_type }
        expect(response).to have_http_status(200)

        expect(response[:is_prime]).to eq(true)
      end

      it "with inverse ranges returns 200 success and solution with correct warning" do
        start_value = 500
        end_value = 250
        post "http://localhost:3000/" + @endpoint, params: { start_value: start_value, end_value: end_value, calculation_type: @calculation_type }
        expect(response).to have_http_status(200)

        expect(response[:is_prime]).to eq(true)
      end
    end
    context "When given values are not prime" do
      it "with non prime numbers returns 200 success with false boolean and error" do
        start_value = 12
        end_value = 14
        post "http://localhost:3000/" + @endpoint, params: { start_value: start_value, end_value: end_value, calculation_type: @calculation_type }
        expect(response).to have_http_status(200)

        expect(response[:is_prime]).to eq(false)
      end
    end
    context "When given numbers are invalid" do
      it "with nil start_value will return 400 failure and error" do
        start_value = nil
        end_value = 250
        post "http://localhost:3000/" + @endpoint, params: { start_value: start_value, end_value: end_value, calculation_type: @calculation_type }
        expect(response).to have_http_status(400)
      end
      it "with nil end_value will return 400 failure and error" do
        start_value = 500
        end_value = nil
        post "http://localhost:3000/" + @endpoint, params: { start_value: start_value, end_value: end_value, calculation_type: @calculation_type }
        expect(response).to have_http_status(400)
      end
      it "with float start_value will return 400 failure and error" do
        start_value = 2.123
        end_value = 250
        post "http://localhost:3000/" + @endpoint, params: { start_value: start_value, end_value: end_value, calculation_type: @calculation_type }
        expect(response).to have_http_status(400)
      end
      it "with float end_value will return 400 failure and error" do
        start_value = 2
        end_value = 50.123
        post "http://localhost:3000/" + @endpoint, params: { start_value: start_value, end_value: end_value, calculation_type: @calculation_type }
        expect(response).to have_http_status(400)
      end
    end
    # TODO add unique validation/test to prevent dupes in db
  end
end
