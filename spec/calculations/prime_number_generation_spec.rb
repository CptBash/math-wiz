require 'rails_helper'

RSpec.describe "Prime Number Calculation", type: :request do
  before(:all) do
    @endpoint = 'calculations/'
    @calculation_type = 'generate_prime'
  end
  describe "POST /create" do

    let(:calculation_params) { { start_value: 0, end_value: 0, calculation_type: @calculation_type } }

    context "When given values are valid" do
      it "with random range of numbers returns 200 success and solution of only prime numbers" do
        calculation_params[:start_value] = rand(0..9000)
        calculation_params[:end_value] = rand(0..9000)
        post "http://localhost:3000/" + @endpoint, params: calculation_params

        expect(response).to have_http_status(200)
        response_body = parse_json(response.body)
        # key validation
        expect(response_body.symbolize_keys.keys).to eq([:id, :calculation_type, :start_value, :end_value, :solution, :error, :created_at, :updated_at])
        # verify that no non prime numbers were returned and no errors
        expect(response_body["solution"]["answer"].any?{|s| s.prime? != true }).to eq(false)
        expect(response_body["error"]).to eq(nil)
      end

      it "with range of 1 - 2 returns 200 success and solution of 2" do
        calculation_params[:start_value] = 1
        calculation_params[:end_value] = 2
        post "http://localhost:3000/" + @endpoint, params: calculation_params
        response_body = parse_json(response.body)
        expect(response_body["solution"]["answer"] == [2]).to eq(true)
      end

      it "with given array of prime numbers returns 200 success and solution" do
        pending("TODO add support in DB for passing array and return only prime numbers from array")
        fail
      end

      it "with given range of non prime numbers returns 200 success and solution with empty array" do
        calculation_params[:start_value] = 0
        calculation_params[:end_value] = 1
        post "http://localhost:3000/" + @endpoint, params: calculation_params
        expect(response).to have_http_status(200)

        response_body = parse_json(response.body)
        expect(response_body["solution"]["answer"].empty?).to eq(true)
        expect(response_body["error"]).to eq("No prime numbers generated")
      end

      it "with range of 7900 - 7920 returns 200 success and correct solution" do
        calculation_params[:start_value] = 7900
        calculation_params[:end_value] = 7920
        correct_solution = [7901, 7907, 7919]
        post "http://localhost:3000/" + @endpoint, params: calculation_params
        expect(response).to have_http_status(200)

        response_body = parse_json(response.body)
        expect(response_body["solution"]["answer"]).to eq(correct_solution)
      end

      it "with inverse ranges returns 200 success and solution" do
        calculation_params[:start_value] = 500
        calculation_params[:end_value] = 250
        post "http://localhost:3000/" + @endpoint, params: calculation_params
        expect(response).to have_http_status(200)

        response_body = parse_json(response.body)
        # verify that no non prime numbers were returned and no errors
        expect(response_body["solution"]["answer"].any?{|s| s.prime? != true }).to eq(false)
        expect(response_body["error"]).to eq(nil)
      end

      it "with invalid calculation_type returns 200 success and invalid calculation_type error" do
        calculation_params[:calculation_type] = "foo-BAR"
        post "http://localhost:3000/" + @endpoint, params: calculation_params
        expect(response).to have_http_status(200)

        response_body = parse_json(response.body)
        expect(response_body["error"]).to eq("unsupported calculation")
      end
    end

    context "When given values are invalid" do
      # TODO this is hacky, update to proper HTTPS codes i.e. 400, 500 codes once strong params is turned back on
      it "with nil start_value will return 200 success and correct error" do
        calculation_params[:start_value] = nil
        calculation_params[:end_value] = 250
        post "http://localhost:3000/" + @endpoint, params: calculation_params
        # expect(response).to have_http_status(400)
        response_body = parse_json(response.body)
        expect(response_body["error"]).to eq("Unsupported start value or end value")
      end

      it "with nil end_value will return 200 success and correct error" do
        calculation_params[:start_value] = 250
        calculation_params[:end_value] = nil

        post "http://localhost:3000/" + @endpoint, params: calculation_params
        # expect(response).to have_http_status(400)
        response_body = parse_json(response.body)
        expect(response_body["error"]).to eq("Unsupported start value or end value")
      end

      it "with float start_value or end_value will return 400 failure and error" do
        pending("TODO fix strong params to require pure integer or this will pass")
        fail
        # calculation_params[:start_value] = 2
        # calculation_params[:end_value] = 50.123
        # post "http://localhost:3000/" + @endpoint, params: calculation_params
        # expect(response).to have_http_status(400)
        # expect(response["error"]).to eq('Please avoid sending float point integers')
      end
    end
  end
  describe "GET /show" do
    before(:all) do
      # create record to validate we can GET with id
      calculation_params = {}
      calculation_params[:start_value] = rand(0..9000)
      calculation_params[:end_value] = rand(0..9000)
      calculation_params = {calculation_type: 'generate_prime', start_value: rand(0..9000), end_value: rand(0..9000)}
      post "http://localhost:3000/" + @endpoint, params: calculation_params

      expect(response).to have_http_status(200)
      response_body = parse_json(response.body)

      @calculation_id = response_body["id"]
    end

    it "with no id returns 200 and all records" do
      get "http://localhost:3000/" + @endpoint
      expect(response).to have_http_status(200)
      response_body = parse_json(response.body)
      expect(response_body.any?{|calculation| calculation["id"] == @calculation_id }).to eq(true)
    end

    it "with valid calculation_id returns 200 and correct record" do
      get "http://localhost:3000/" + @endpoint + @calculation_id.to_s
      expect(response).to have_http_status(200)
      response_body = parse_json(response.body)
      expect(response_body["id"]).to eq(@calculation_id)
    end

    it "with invalid calculation_id returns 422 record not found error" do
      get "http://localhost:3000/" + @endpoint + "foo-BAR"
      expect(response).to have_http_status(422)
      response_body = parse_json(response.body)
      expect(response_body["errors"]).to eq("Couldn't find Calculation with 'id'=foo-BAR")
    end
  end
  describe "DELETE /destroy" do
    before(:all) do
      # create record to validate DELETE with id
      calculation_params = {}
      calculation_params[:start_value] = rand(0..9000)
      calculation_params[:end_value] = rand(0..9000)
      calculation_params = {calculation_type: 'generate_prime', start_value: rand(0..9000), end_value: rand(0..9000)}
      post "http://localhost:3000/" + @endpoint, params: calculation_params

      expect(response).to have_http_status(200)
      response_body = parse_json(response.body)

      @calculation_id = response_body["id"]
    end

    it "with valid id returns 204 record destroyed" do
      delete("http://localhost:3000/" + @endpoint + @calculation_id.to_s)
      expect(response).to have_http_status(204)

      # validate GET fails
      get "http://localhost:3000/" + @endpoint + @calculation_id.to_s
      expect(response).to have_http_status(422)
      response_body = parse_json(response.body)
      expect(response_body["errors"]).to eq("Couldn't find Calculation with 'id'=#{@calculation_id.to_s}")
    end

    it "with invalid calculation_id returns 422 record not found error" do
      get "http://localhost:3000/" + @endpoint + "foo-BAR"
      expect(response).to have_http_status(422)
      response_body = parse_json(response.body)
      expect(response_body["errors"]).to eq("Couldn't find Calculation with 'id'=foo-BAR")
    end
  end
end
