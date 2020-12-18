# frozen_string_literal: true

module V1
  class Ideas < Grape::API
    resources :ideas do
      desc 'return all ideas'

      params do
        optional :category_name, type: String
      end

      get '/' do
        ideas = Idea.all
        categories = Category.all

        categories = categories.where(name: params[:category_name]) if params[:category_name].present?
        return status(404) if categories.blank?

        ideas = ideas.where(category: categories)

        # present @ideas, with: V1::Entities::IdeaEntity
        response_data = []
        ideas.map do |idea|
          response_data << { 'id': idea.id, 'category': idea.category.name, 'body': idea.body }
        end
        {
          data: response_data
        }
      end

      desc 'Create an idea'

      params do
        requires :category_name, type: String
        requires :body, type: String
      end

      post do
        # 新規カテゴリなら保存
        category = Category.find_or_initialize_by(name: params[:category_name])
        if category.new_record?
          if category.save
            Idea.create!(category: category, body: params[:body])
            status 201
          else
            status 422
          end
        else
          idea = Idea.new(category: category, body: params[:body])
          if idea.save
            status 201
          else
            status 422
          end
        end
        # category = Category.find_by!(name: params[:category_name])
      end
    end
  end
end
