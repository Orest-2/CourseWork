require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :request do
    let!(:user) {FactoryBot.create(:user)}
    let!(:product) {user.products.create(name: "product", description: "descr", product_type: 1)}

    describe "GET product#index" do
        it "should show all product of current user" do 
            login(user)
            headers = get_auth_params_from_login_response_headers(response)
            user.products.create(name: "product2", description: "descr2", product_type: 2)
            get '/api/v1/products', params: nil, headers: headers
            json = JSON.parse(response.body)
            expect(json["success"]).to eq(true)
            expect(response.status).to eq(200)
            expect(json["products"].length).to eq(user.products.length)
            expect(json["products"][0]["name"]).to eq("product")
            expect(json["products"][1]["name"]).to eq("product2")
        end
    end

    describe "GET product#show" do 
        it "should show product" do 
            login(user)
            headers = get_auth_params_from_login_response_headers(response)
            get '/api/v1/products/1', params: nil, headers: headers
            json = JSON.parse(response.body)
            expect(response.status).to eq(200)
            expect(json["product"]["description"]).to eq("descr")
        end
    end

    describe "POST product#create" do 
        it "should create product" do 
            login(user)
            headers = get_auth_params_from_login_response_headers(response)
            post '/api/v1/products', params: {product: {name: "product_new", description: "descr_new", product_type: 01} }, headers: headers
            json = JSON.parse(response.body)
            expect(response.status).to eq(201)
            expect(json["product"]["name"]).to eq("product_new")
        end
    end

    describe "PUT product#update" do
        it "should update product params" do
            login(user)
            headers = get_auth_params_from_login_response_headers(response)
            put '/api/v1/products/1', params: {product: {name: "product_updated", description: "descr_updated", product_type: 01} }, headers: headers
            json = JSON.parse(response.body)
            expect(response.status).to eq(200)
            expect(json["product"]["name"]).to eq("product_updated")
            expect(user.products[0].name).to eq("product_updated")
            expect(json["product"]["description"]).to eq("descr_updated")
        end
    end

    describe "DEL product#destroy" do 
        it "should delete product" do
            login(user)
            headers = get_auth_params_from_login_response_headers(response)
            user.products.create(name: "product2", description: "descr2", product_type: 2)
            delete '/api/v1/products/2', params: nil, headers: headers
            json = JSON.parse(response.body)
            expect(response.status).to eq(200)
            expect(json["success"]).to eq(true)
        end
    end

end
