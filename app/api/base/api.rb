# frozen_string_literal: true

module Base
  class Api < Grape::API
    prefix 'api'
    mount V1::Root
  end
end
