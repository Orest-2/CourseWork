require 'rails_helper'

RSpec.describe Api::V1::UserParamsController, type: :request do
    let!(:user) {FactoryBot.create(:user)}
    let!(:user_param) {user.build_user_param(first_name: "tester", last_name: "testerow", 
                  email: "test@gmail.com", address: "Ungvar s. Radvanka 5") }
               #before(:each) do
              #   @current_user = FactoryBot.create(:user)
                #end                 

    describe "POST user_param#create" do 
     it "should create user_param" do
        login(user)
        auth_params = get_auth_params_from_login_response_headers(response)
        post '/api/v1/user/params', params: {user_param: nil}, headers: auth_params
        pp json = JSON.parse(response.body)
        expect(json["success"]).to eq(true)
        expect(response.status).to eq(201)
        end
     it "should render error, user already exist" do
          login(user)
          headers = get_auth_params_from_login_response_headers(response)
          post '/api/v1/user/params', params: {current_user: user, user_param: user.user_param}, headers: headers
          pp json = JSON.parse(response.body)
          expect(json["msg"]).to eq("user params already exist")
        end  
     
      

        def get_auth_params_from_login_response_headers(response)
            client = response.headers["client"]
            token = response.headers['access-token']
            expiry = response.headers['expiry']
            token_type = response.headers['token-type']  
            uid =   response.headers['uid']  
      
            auth_params = {
                            'access-token' => token,
                            'client' => client,
                            'uid' => uid,
                            'expiry' => expiry,
                            'token_type' => token_type
                          }
            auth_params
        end
    end
    def login(user)
      post '/auth/sign_in', params:  { email: "test@gmail.com", password: "pass_123"}.to_json,
                            headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    end 
  
end
