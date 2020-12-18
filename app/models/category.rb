# frozen_string_literal: true

class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :ideas, foreign_key: 'category', inverse_of: :category, dependent: :destroy
end
