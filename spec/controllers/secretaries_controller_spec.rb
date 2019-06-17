require 'rails_helper'

RSpec.describe Api::V1::SecretariesController, type: :request do
    let!(:secretary) {FactoryBot.create(:secretary)}
    let!(:cop_app) {CopyrightApplication.create(customer_id: 12, title: "cop_app_new",
                                                description: "test_new_cop_app", product_id: 1)}

    describe "GET secretaries/copyright_applications#accept/decline" do
        it "should accept copyright application" do 
            login(secretary)
            headers = get_auth_params_from_login_response_headers(response)
            get '/api/v1/secretaries/copyright_applications/accept/1', params: nil, headers: headers
            expect(response.status).to eq(200)       
            json = JSON.parse(response.body)
            expect(json["copyright_application"]["status"]).to eq(20) 
            expect(json["copyright_application"]["director_id"]).to eq(10)
            expect(json["copyright_application"]["acceptor_id"]).to eq(secretary.id)
        end

        it "should decline copyright application" do 
            login(secretary)
            headers = get_auth_params_from_login_response_headers(response)
            get '/api/v1/secretaries/copyright_applications/accept/1', params: nil, headers: headers
            expect(response.status).to eq(200)       
            json = JSON.parse(response.body)
            expect(json["copyright_application"]["status"]).to eq(10) 
            expect(json["copyright_application"]["director_id"]).to eq(nil)
            expect(json["copyright_application"]["acceptor_id"]).to eq(nil)
        end
    end
end
