# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ideas api', type: :request do
  describe 'GET /api/v1/ideas' do
    before do
      category = create(:category, name: 'test')
      create(:idea, category: category)
      create_list(:idea, 3)
    end

    let(:body) { 'test' }

    context '正しいリクエストをすると正しいレスポンスが返ってくること' do
      it 'パラメータなしの場合' do
        get '/api/v1/ideas'
        response_body = JSON.parse(response.body)
        aggregate_failures '正常に動作する' do
          expect(response.status).to(eq(200))
          expect(response_body['data'].count).to(eq(4))
        end
      end

      it 'パラメータありの場合' do
        get "/api/v1/ideas?category_name=#{body}"
        aggregate_failures '正常に動作する' do
          expect(response.status).to(eq(200))
        end
      end
    end

    context '登録されていないリクエストをすると404を返すこと' do
      let(:body) { 'test2' }

      it '登録されていないリクエストの場合' do
        get "/api/v1/ideas?category_name=#{body}"
        aggregate_failures 'レスポンスステータスが404になる' do
          expect(response.status).to(eq(404))
        end
      end
    end
  end

  describe 'POST /api/v1/ideas' do
    before do
      category = create(:category, name: 'test')
      create(:idea, category: category, body: 'test1')
    end

    let(:category_name) { 'test' }
    let(:body) { 'test2' }

    context 'カテゴリー名が存在する場合' do
      let(:category_count) { Category.count }
      let(:idea_count) { Idea.count }
      let(:category_created_name) { Category.last.name }
      let(:idea_created_name) { Idea.last.body }

      it 'catetoryは新しいレコードが作られず' do
        post "/api/v1/ideas?category_name=#{category_name}&body=#{body}"
        aggregate_failures 'ideaだけ登録され２つになる' do
          expect(category_count).to(eq(1))
          expect(category_created_name).to(eq('test'))
          expect(idea_count).to(eq(2))
          expect(idea_created_name).to(eq('test2'))
        end
      end
    end

    context 'カテゴリー名が存在しない場合' do
      let(:category_name) { 'category2' }
      let(:body) { 'body2' }
      let(:category_count) { Category.count }
      let(:idea_count) { Idea.count }
      let(:category_created_name) { Category.last.name }
      let(:idea_created_name) { Idea.last.body }

      it 'catetoryは新しいレコードが作られ' do
        post "/api/v1/ideas?category_name=#{category_name}&body=#{body}"
        aggregate_failures 'ideaも登録され２つになる' do
          expect(category_count).to(eq(2))
          expect(category_created_name).to(eq('category2'))
          expect(idea_count).to(eq(2))
          expect(idea_created_name).to(eq('body2'))
        end
      end
    end
  end
end
