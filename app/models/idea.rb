# frozen_string_literal: true

class Idea < ApplicationRecord
  belongs_to :category

  validates :category_id, presence: true
  validates :body, presence: true
end
