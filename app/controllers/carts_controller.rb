class CartsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: %i[edit update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invaild_cart

  def show
    @cart = Cart.find(session[:cart_id])
    return if Cart.find(params[:id]) != @cart.id
  end

  def destroy
    if @cart.id != nil && @cart.id == session[:cart_id]
      @cart.destroy
      session[:cart_id] = nil
      redirect_to '/', notice: 'Your cart is currently deleted.'
    else
      redirect_to cart_url, notice: 'Sorry, this cart not found for deletion.'
    end
  end

  private

  def invaild_cart
    logger.error "Attempt to access invalid cart #{params[:id]}"
    redirect_to root_url, notice: 'Sorry, you are querying an invalid cart'
  end
end
