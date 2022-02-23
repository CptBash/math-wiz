class Calculation < ApplicationRecord
  store :solution, accessors: [ :answer ], coder: JSON
end
