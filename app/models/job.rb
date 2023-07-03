class Job < ApplicationRecord
  enum difficulty: [:easy, :medium, :hard]
end
