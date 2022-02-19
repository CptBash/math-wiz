require 'rails_helper'

RSpec.describe "Prime Number Calculation", type: :request do
  describe "POST /create" do
    context "When given values are prime" do
      it "with random prime numbers returns 200 success and solution" do
      end

      it "with range of 7900 - 7920 returns 200 success and solution" do
      end

      it "with inverse ranges returns 200 success and solution with correct warning" do
      end
    end
    context "When given values are not prime" do
      it "with random non prime numbers returns 200 success with false boolean and error" do
      end
    end
    context "When given numbers are invalid" do
      it "with nil start_value will return 400 failure and error" do
      end
      it "with nil end_value will return 400 failure and error" do
      end
      it "with float start_value will return 400 failure and error" do
      end
      it "with float end_value will return 400 failure and error" do
      end
    end
    # TODO add unique validation/test to prevent dupes in db
  end
end
