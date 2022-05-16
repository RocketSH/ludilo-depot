class LineItemsController < ApplicationController
  before_action :only => [:create] do
    redirect_to new_user_session_path, notice: 'Please login before adding products to your cart.' unless current_user
  end
  include CurrentCart
  before_action :set_cart, only: %i[create destroy]
  before_action :set_line_item, only: %i[update destroy]

  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)

    respond_to do |format|
      if @line_item.save
        reset_counter
        format.html { redirect_to root_url }
        format.js { @current_item = @line_item }
      else
        format.html { render :new }
      end
    end
  end

  def update
    if @line_item.minus_line_item_qty
      redirect_to '/', notice: 'Product was successfully revised quantity.'
    else
      redirect_to '/', notice: 'Sorry, this product quantity can not be revised.'
    end
  end

  def destroy
    @line_item.destroy
    session[:line_item_id] = nil

    redirect_to @cart, notice: 'Product was successfully removed from your shopping cart.'
  end

  private

  def set_line_item
    @line_item = LineItem.find(params[:id])
  end

  def reset_counter
    session[:counter] = 0
  end

  def line_item_params
    params.require(:line_item).permit(:product_id, :cart_id, :quantity, :price)
  end
end
