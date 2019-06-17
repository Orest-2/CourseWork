require 'rails_helper'

RSpec.describe Api::V1::DirectorsController, type: :request do
    let!(:director) {FactoryBot.create(:admin)}

    describe "POST directors#create" do 
        it "should create user" do 
            login(director)
            headers = get_auth_params_from_login_response_headers(response)
            post '/api/v1/director/users', params: { uid: "tester123@gmail.com", email: "tester123@gmail.com", password: "pas_1234",
                                                     password_confirmation: "pas_1234", belong_to: director.id, type: "secretary"},
                                                     headers: headers 
            expect(response.status).to eq(201)
            json = JSON.parse(response.body)
            expect(json["user"]["email"]).to eq("tester123@gmail.com")
            expect(json["user"]["is_secretary"]).to eq(true)
            expect(json["user"]["belong_to"]).to eq(director.id)
        end
    end

    describe "DELETE directors#destroy" do
        it "should destroy user" do
            login(director)
            headers = get_auth_params_from_login_response_headers(response)
            User.create( uid: "tester123@gmail.com", email: "tester123@gmail.com", password: "pas_1234",
                         password_confirmation: "pas_1234", belong_to: director.id, is_secretary: true  )
            delete '/api/v1/director/users/1', params: nil, headers: headers
            expect(response.status).to eq(200)
        end
    end

    describe "GET directors#index" do
        it "should show list of users, that was created by current director" do
            login(director)
            headers = get_auth_params_from_login_response_headers(response)
            User.create( uid: "tester123@gmail.com", email: "tester123@gmail.com", password: "pas_1234",
                         password_confirmation: "pas_1234", belong_to: director.id, is_secretary: true  )
            User.create( uid: "tester321@gmail.com", email: "tester321@gmail.com", password: "pas_1234",
                         password_confirmation: "pas_1234", belong_to: director.id, is_executor: true  )
            User.create( uid: "test123321@gmail.com", email: "test123321@gmail.com", password: "pas_1234",
                         password_confirmation: "pas_1234", belong_to: 101, is_secretary: true  )     
            get '/api/v1/director/users', params: nil, headers: headers
            expect(response.status).to eq(200)
            json = JSON.parse(response.body)
            expect(json["secretaries"][0]["email"]).to eq("tester123@gmail.com")
            expect(json["secretaries"][0]["belong_to"]).to eq(director.id)
            expect(json["executor"][0]["email"]).to eq("tester321@gmail.com")
            expect(json["executor"][0]["belong_to"]).to eq(director.id)
        end
    end

end
