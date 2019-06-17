require 'rails_helper'

RSpec.describe Api::V1::UserParamsController, type: :request do
    let!(:user) {FactoryBot.create(:user)}
    let!(:user_param) {user.build_user_param(first_name: "tester", last_name: "testerow", 
                       email: "test@gmail.com", address: "Ungvar s. Radvanka 5").save}              

    describe "POST user_param#create" do 
     it "should create user_param" do
        sign_up(user)
        auth_params = get_auth_params_from_login_response_headers(response)
        post '/api/v1/user/params', params: {first_name: "tester", last_name: "testerow", 
                                             email: "qasad@gmail.com", address: "Ungvar s. Radvanka 5"}, 
                                             headers: auth_params
        json = JSON.parse(response.body)
        expect(json["success"]).to eq(true)
        expect(response.status).to eq(201)
        end

     it "should render error, user_param already exist" do
          login(user)
          headers = get_auth_params_from_login_response_headers(response)
          post '/api/v1/user/params', params: {first_name: "tester1", last_name: "testerow2", 
                                      email: "qasad@gmail.com", address: "Ungvar s. Radvanka 5"}, 
                                      headers: headers
          json = JSON.parse(response.body)
          expect(response.status).to eq(400)
          expect(json["success"]).to eq(false)
          expect(json["msg"]).to eq(['user params already exist'])
        end  
      end

    describe "GET user_param#show" do
      it "should show user_param" do
        login(user)
        headers = get_auth_params_from_login_response_headers(response)
        get '/api/v1/user/params', params: nil, headers: headers
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json["success"]).to eq(true)
        expect(json["user_param"]["first_name"]).to eq("tester")
        expect(json["user_param"]["email"]).to eq("test@gmail.com")
      end

      it "should render error, params doesn't exist" do 
        sign_up(user)
        headers = get_auth_params_from_login_response_headers(response)
        get '/api/v1/user/params', params: nil, headers: headers
        expect(response.status).to eq(400)
        json = JSON.parse(response.body)
        expect(json["success"]).to eq(false)
        expect(json["msg"]).to eq(["user params doesn't exist"])
      end
    end

    describe "PUT user_param#update" do
      it "should update user_param" do 
        login(user)
        headers = get_auth_params_from_login_response_headers(response)
        put '/api/v1/user/params', params: {first_name: "tester_upd", last_name: "testerow_upd", 
                                            email: "qasad@gmail.com_upd", address: "Ungvar s. Radvanka 5 _upd"}, 
                                            headers: headers
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json["user_param"]["first_name"]).to eq("tester_upd")
        expect(json["user_param"]["last_name"]).to eq("testerow_upd")
        expect(json["user_param"]["email"]).to eq("qasad@gmail.com_upd")
        expect(json["user_param"]["address"]).to eq("Ungvar s. Radvanka 5 _upd")
      end

      it "should render error, params doesn't exist" do 
        sign_up(user)
        headers = get_auth_params_from_login_response_headers(response)
        put '/api/v1/user/params', params: {first_name: "tester_upd", last_name: "testerow_upd", 
                                            email: "qasad@gmail.com_upd", address: "Ungvar s. Radvanka 5 _upd"}, 
                                            headers: headers
        expect(response.status).to eq(400)
        json = JSON.parse(response.body)
        expect(json["success"]).to eq(false)
        expect(json["msg"]).to eq(["user params doesn't exist"])
      end
    end
end
