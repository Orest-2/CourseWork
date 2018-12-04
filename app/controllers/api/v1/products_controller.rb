class Api::V1::ProductsController < ApplicationController
  before_action :auth_user_as_customer
  before_action :product, except: %i[index create]

  def index
    render json: {
      owner: current_user,
      products: current_user.products
    }
  end

  def create
    @prod = current_user.products.create(prod_param)

    if @prod.save
      index
    else
      render_error
    end
  end

  def show
    render json: product
  end

  def update
    if @prod.update(prod_param)
      index
    else
      render_error
    end
  end

  def destroy
    @prod.destroy
    index
  end

  private

  def product
    @prod = current_user.products.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    @error = e.message
    render_error
  end

  def render_error
    msg = @prod.errors.full_messages unless @prod.nil?
    msg ||= [@error.split('[').first]

    render json: {
      success: false,
      msg: msg
    }
  end

  def prod_param
    params.require(:product).permit(:name, :description)
  end
end
