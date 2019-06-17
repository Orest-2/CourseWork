require 'rails_helper'

RSpec.describe Api::V1::CopyrightApplicationTasksController, type: :request do
    let!(:user) {FactoryBot.create(:user)}
    let!(:product) {user.products.create(name: "product", description: "descr", product_type: 1).save}
    let!(:cop_app) { CopyrightApplication.create(customer_id: user.id, title: "cop_app_new", 
                                                 description: "test_new_cop_app", product_id: user.products[0].id) }

    describe "POST copyright_application_tasks#create" do
        it "should create task for copyright application" do
            login(user)
            headers = get_auth_params_from_login_response_headers(response)
            post '/api/v1/copyright_applications/tasks', params: {copyright_application_id: cop_app.id, title: "testing_task"}, headers: headers
            expect(response.status).to eq(201)
            json = JSON.parse(response.body)
            expect(json["copyright_application_task"]["title"]).to eq("testing_task")
        end
    end

    describe "PUT  copyright_application_tasks#update" do
        it "should update copyright application task" do 
            login(user)
            headers = get_auth_params_from_login_response_headers(response)
            application = CopyrightApplication.create(customer_id: user.id, title: "cop_app_new", description: "test_new_cop_app", product_id: user.products[0].id)
            application.copyright_application_tasks.create(title: "title1")
            put '/api/v1/copyright_applications/tasks/1', params: {title: "testing_task"}, headers: headers
            expect(response.status).to eq(200)
            json = JSON.parse(response.body)
            expect(json["copyright_application_task"]["title"]).to eq("testing_task")
        end
    end

    describe "DELETE copyright_application_tasks#destroy" do
        it "should destroy task from copyright application" do
            login(user)
            headers = get_auth_params_from_login_response_headers(response)
            application = CopyrightApplication.create(customer_id: user.id, title: "cop_app_new", description: "test_new_cop_app", product_id: user.products[0].id)
            application.copyright_application_tasks.create(title: "title1")
            application.copyright_application_tasks.create(title: "title2")
            delete '/api/v1/copyright_applications/tasks/1', params: nil, headers: headers
            expect(response.status).to eq(200)
            get '/api/v1/copyright_applications/2', params: nil, headers: headers
            json = JSON.parse(response.body)
            expect(json["copyright_application"]["tasks"][0]["title"]).to eq("title2")
        end
    end 
end
