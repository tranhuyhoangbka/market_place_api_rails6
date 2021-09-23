class Api::V1::ProductsController < ApplicationController
  include Paginable

  before_action :set_product, only: %i(show update destroy)
  before_action :check_login, only: %i(create)
  before_action :check_owner, only: %i(update destroy)

  def index
    @products = Product.search(params).page(current_page).per(per_page)
    options = get_links_serializer_options('api_v1_products_path', @products, {include: [:user]})
    render json: ProductSerializer.new(@products, options).serializable_hash
  end

  def show
    render json: ProductSerializer.new(@product, include: [:user]).serializable_hash
  end

  def create
    product = current_user.products.build(product_params)
    if product.save
      render json: ProductSerializer.new(product, include: [:user]).serializable_hash, status: :created
    else
      render json: {errors: product.errors}, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: ProductSerializer.new(@product, include: [:user]).serializable_hash
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head 204
  end

  private
  def set_product
    @product = Product.find(params[:id])
  end

  def check_owner
    head :forbidden unless @product.user_id == current_user&.id
  end

  def product_params
    params.require(:product).permit(:title, :price, :published)
  end
end
