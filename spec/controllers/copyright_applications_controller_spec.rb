require 'rails_helper'

RSpec.describe Api::V1::CopyrightApplicationsController, type: :request do
    let!(:user) {FactoryBot.create(:user)}
    let!(:product) {user.products.create(name: "product", description: "descr", product_type: 1).save}
    
    describe "POST copyright_applications_controller#create" do
        it "should create copyright_application" do
            login(user)
            headers = get_auth_params_from_login_response_headers(response)
            post '/api/v1/copyright_applications', params: { product_id: user.products[0].id, tasks: [ {title: "first_one",}, {title: "second"} ],
                                                             copyright_application: { customer_id: user.id, title: "cop_app_new", 
                                                             description: "test_new_cop_app", product_id: user.products[0].id } }, headers: headers
            expect(response.status).to eq(201)
            json = JSON.parse(response.body)
            expect(json["copyright_application"]["description"]).to eq("test_new_cop_app")
            expect(json["copyright_application"]["tasks"][1]["title"]).to eq("second")
        end
    end

    describe "GET copyright_applications_controller#show" do
        it "should show copyright_application" do
            login(user)
            headers = get_auth_params_from_login_response_headers(response)
            application = CopyrightApplication.create(customer_id: user.id, title: "cop_app_new", description: "test_new_cop_app", product_id: user.products[0].id)
            application.copyright_application_tasks.create(title: "title1")
            get '/api/v1/copyright_applications/1', params: nil, headers: headers
            expect(response.status).to eq(200)
            json = JSON.parse(response.body)
            expect(json["copyright_application"]["description"]).to eq("test_new_cop_app")
            expect(json["copyright_application"]["tasks"][0]["title"]).to eq("title1")
        end
    end

    describe "PUT copyright_applications_controller#update" do
        it "should update copyright_application" do
            login(user)
            headers = get_auth_params_from_login_response_headers(response)
            application = CopyrightApplication.create(customer_id: user.id, title: "cop_app_new", description: "test_new_cop_app", product_id: user.products[0].id)
            application.copyright_application_tasks.create(title: "title1")
            put '/api/v1/copyright_applications/1', params: { copyright_application: { customer_id: user.id, title: "test_new_title", 
                                                              description: "test_new_description", product_id: user.products[0].id } }, headers: headers
            expect(response.status).to eq(200)
            json = JSON.parse(response.body)
            expect(json["copyright_application"]["description"]).to eq("test_new_description")
            expect(json["copyright_application"]["title"]).to eq("test_new_title")
        end
    end

    describe "DELETE copyright_applications_controller#destroy" do
        it "should destroy copyright_application" do 
            login(user)
            headers = get_auth_params_from_login_response_headers(response)
            application = CopyrightApplication.create(customer_id: user.id, title: "cop_app_new", description: "test_new_cop_app", product_id: user.products[0].id)
            application.copyright_application_tasks.create(title: "title1")
            application.copyright_application_tasks.create(title: "title2")
            delete '/api/v1/copyright_applications/1', params: nil, headers: headers
            expect(response.status).to eq(200)           
            get '/api/v1/copyright_applications/1', params: nil, headers: headers
            json = JSON.parse(response.body)
            expect(json["success"]).to eq(false)
            expect(json["msg"]).to eq(["Couldn't find CopyrightApplication with 'id'=1"])
        end
    end

    describe "GET copyright_applications_controller#index" do 
        it "should show list of copyright_applications" do 
            login(user)
            headers = get_auth_params_from_login_response_headers(response)
            application = CopyrightApplication.create(customer_id: user.id, title: "cop_app_new", description: "test_new_cop_app", product_id: user.products[0].id)
            application.copyright_application_tasks.create(title: "title1")
            application.copyright_application_tasks.create(title: "title2")
            application = CopyrightApplication.create(customer_id: user.id, title: "cop_app_new2", description: "test_new_cop_app2", product_id: user.products[0].id)
            application.copyright_application_tasks.create(title: "title3")
            application.copyright_application_tasks.create(title: "title4")
            get '/api/v1/copyright_applications', params: nil, headers: headers
            expect(response.status).to eq(200)           
            json = JSON.parse(response.body)
            expect(json["copyright_applications"][0]["title"]).to eq("cop_app_new")
            expect(json["copyright_applications"][1]["title"]).to eq("cop_app_new2")
        end
    end

    describe "GET copyright_applications_controller#submit/unsubmit" do
        it "should change status of application to '10'" do
            login(user)
            headers = get_auth_params_from_login_response_headers(response)
            application = CopyrightApplication.create(customer_id: user.id, title: "cop_app_new", description: "test_new_cop_app", product_id: user.products[0].id)
            application.copyright_application_tasks.create(title: "title1")
            application.copyright_application_tasks.create(title: "title2")
            get '/api/v1/copyright_applications/submit/1', params: nil, headers: headers
            expect(response.status).to eq(200)           
            json = JSON.parse(response.body)
            expect(json["copyright_application"]["status"]).to eq(10)
        end

        it "should change status of application to '0'" do
            login(user)
            headers = get_auth_params_from_login_response_headers(response)
            application = CopyrightApplication.create(customer_id: user.id, title: "cop_app_new", description: "test_new_cop_app", product_id: user.products[0].id)
            application.copyright_application_tasks.create(title: "title1")
            application.copyright_application_tasks.create(title: "title2")
            get '/api/v1/copyright_applications/submit/1', params: nil, headers: headers
            get '/api/v1/copyright_applications/unsubmit/1', params: nil, headers: headers
            expect(response.status).to eq(200)           
            json = JSON.parse(response.body)
            expect(json["copyright_application"]["status"]).to eq(0)
        end
    end

    describe "GET copyright_applications_controller#sharing/done" do
        it "should change status of application to '30'" do 
            secretary = FactoryBot.create(:secretary)
            login(secretary)
            headers = get_auth_params_from_login_response_headers(response)
            application = CopyrightApplication.create(customer_id: user.id, title: "cop_app_new", description: "test_new_cop_app", product_id: user.products[0].id)
            application.copyright_application_tasks.create(title: "title1")
            application.copyright_application_tasks.create(title: "title2")
            post '/api/v1/copyright_applications/share', params: {executor_id: secretary.id, id: user.products[0].id}, headers: headers
            expect(response.status).to eq(200)       
            json = JSON.parse(response.body)
            expect(json["copyright_application"]["status"]).to eq(30)    
        end

        it "should change status of application to '40'" do
            secretary = FactoryBot.create(:secretary)
            login(secretary)
            headers = get_auth_params_from_login_response_headers(response)
            application = CopyrightApplication.create(customer_id: user.id, title: "cop_app_new", description: "test_new_cop_app", product_id: user.products[0].id)
            application.copyright_application_tasks.create(title: "title1")
            application.copyright_application_tasks.create(title: "title2")
            get '/api/v1/copyright_applications/done/1', params: nil, headers: headers
            expect(response.status).to eq(200)       
            json = JSON.parse(response.body)
            expect(json["copyright_application"]["status"]).to eq(40) 
        end
    end
end
