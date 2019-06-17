class Api::V1::CustomSearchController < ApplicationController
    include UserAccessChecker
    #before_action :auth_user_as_admin
    require 'google/apis/customsearch_v1'
    Search = Google::Apis::CustomsearchV1
  
      def search 
        product = Product.find(params[:id]) 
        query = product.description
        search_client = Search::CustomsearchService.new
        search_client.key = 'AIzaSyDd-h79RNnVuNTeZkDiS3d6qoLfvP9TzVg'
        response = search_client.list_cses(query, {cx: '014522878819943434827:capsrcnxzkg'})
        
        render status: 200, json: {
          success: true,
          result: response.items
        }
    end
  end