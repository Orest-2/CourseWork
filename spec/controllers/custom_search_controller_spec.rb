require 'rails_helper'

RSpec.describe Api::V1::CustomSearchController, type: :request do
    let!(:user) {FactoryBot.create(:user)}
    let!(:product) {user.products.create(name: "product", description: "poops", product_type: 1)}

    describe "POST custom_search#search" do 
        it "should find products with similar description" do
            login(user)
            headers = get_auth_params_from_login_response_headers(response)
            post '/api/v1/copyright_applications/custom_search', params: {id: product.id}, headers: headers
            expect(response.status).to eq(200)
            json = JSON.parse(response.body)
            expect(json["result"]).to_not eq(nil)
        end
    end
end
