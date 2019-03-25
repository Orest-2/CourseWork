class Api::V1::ProductsController < ApplicationController
  before_action :auth_user_as_customer
  before_action :product, except: %i[index create]

  def index
    render status: 200, json: {
      success: true,
      products: current_user.products
    }
  end

  def create
    @product = current_user.products.create(product_params)

    if @product.save
      render status: 201, json: {
        success: true,
        product: @product
      }
    else
      render_error(400, @product)
    end
  end

  def show
    render status: 200, json: {
      success: true,
      product: @product
    }
  end

  def update
    if @product.update(product_params)
      render status: 200, json: {
        success: true,
        product: @product
      }
    else
      render_error(400, @product)
    end
  end

  def destroy
    @product.destroy
    render status: 200, json: {
      success: true
    }
  end

  private

  def product
    @product = current_user.products.find(params[:id])
  rescue StandardError => e
    @error = e.message
    render_error(400, nil, @error)
  end

  def product_params
    params.require(:product).permit(:name, :description, :product_type)
  end
end
