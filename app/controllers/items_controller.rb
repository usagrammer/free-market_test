class ItemsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :set_item, only: [:edit, :update, :destroy]
  before_action :user_is_not_seller, only: [:edit, :update, :destroy] ## 追加

  def index
    ladies_category = Category.find_by(name: "レディース")
    mens_category = Category.find_by(name: "メンズ")
    kids_category = Category.find_by(name: "ベビー・キッズ")

    ladies_items = Item.search_by_categories(ladies_category.subtree).new_items
    mens_items = Item.search_by_categories(mens_category.subtree).new_items
    kids_items = Item.search_by_categories(kids_category.subtree).new_items

    @new_items_arrays = [
       {category: ladies_category, items: ladies_items},
       {category: mens_category, items: mens_items},
       {category: kids_category, items: kids_items}
      ]
  end

  def new
    @item = Item.new  ## 追加
    @item.images.build
    render layout: 'no_menu' # レイアウトファイルを指定
  end

  ## -----追加①ここから-----
  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path, notice: "出品に成功しました"
    else
      redirect_to new_item_path, alert: @item.errors.full_messages  ## ここを変更
    end
  end
  ## -----追加①ここまで-----

  def edit
    @item.images.build
    render layout: 'no_menu' # レイアウトファイル指定
  end

  def update
    if @item.update(item_params)
      redirect_to root_path, notice: "商品の編集が完了しました。"
    else
      redirect_to edit_item_path(@item), alert: @item.errors.full_messages ## ここを変更
    end
  end

  def destroy
    if @item.destroy
      redirect_to root_path, notice: "商品の削除が完了しました。"
    else
      render layout: 'no_menu', action: :edit
    end
  end

  def purchase_confirmation
    render layout: 'no_menu' # レイアウトファイル指定
  end

  ## -----追加②ここから-----
  private
  def item_params
    params.require(:item).permit(
      :name,
      :price,
      :detail,
      :condition,
      :delivery_fee_payer,
      :delivery_method,
      :delivery_days,
      :prefecture_id,
      :category_id,
      images_attributes: [:src, :id, :_destroy]  ##  追加
      ).merge(seller_id: current_user.id)
  end
  ## -----追加②ここまで-----

  ## 追加
  def set_item
    @item = Item.find(params[:id])
  end

  ## -----追加ここから-----
  def user_is_not_seller
    redirect_to root_path, alert: "あなたは出品者ではありません" unless @item.seller_id == current_user.id
  end
  ## -----追加ここまで-----

end
