class LineItemsController < ApplicationController
  # TODO: think about if it is worth including a privacy method
  include CurrentCart
  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  def create
    product = Product.find(params[:product_id])
    # build a new line item relationship between the @cart object and the product
    @line_item = @cart.add_product(product)

    if @line_item.save
      reset_counter
      redirect_to @line_item.cart, notice: 'Product was successfully added into your shopping cart.'
    else
      render :new
    end
  end

  def new
  end

  def show
  end

  def edit
  end

  def destroy
    @line_item.destroy

    redirect_to @cart, notice: "Product was successfully removed from your shopping cart." 
  end

  private

  def set_line_item
    @line_item = LineItem.find(params[:id])
  end

  def reset_counter
    session[:counter] = 0
  end
end
