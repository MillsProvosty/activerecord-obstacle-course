require 'rails_helper'

describe 'ActiveRecord Obstacle Course, Week 3' do

# Looking for your test setup data?
# It's currently inside /spec/rails_helper.rb
# Not a very elegant solution, but works for this iteration.

# Here are the docs associated with ActiveRecord queries: http://guides.rubyonrails.org/active_record_querying.html

# ----------------------

  xit '16. returns the names of users who ordered one specific item' do
    #Ask for help- don't get hung up on this one!!!
    expected_result = [@user_2.name, @user_3.name, @user_1.name]

    # ----------------------- Using Raw SQL-----------------------
    # users = ActiveRecord::Base.connection.execute("
    #   select
    #     distinct users.name
    #   from users
    #     join orders on orders.user_id=users.id
    #     join order_items ON order_items.order_id=orders.id
    #   where order_items.item_id=#{@item_8.id}
    #   ORDER BY users.name")
    # users = users.map {|u| u['name']}
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    users = User.joins(0).where('order_items.item_id' => @item_8.id).distinct.order(:name).pluck(:name)

    users = User.joins(:order_items).where("order_items.item_id => #{@item_8.id}").order(:name).distinct.pluck(:name)

    users = User.joins(:order_items).where("order_items.item_id" = ?, @item_8.id).order(:name).distinct.pluck(:name)
    # ------------------------------------------------------------

    # Expectation
    expect(users).to eq(expected_result)
  end

  xit '17. returns the name of items associated with a specific order' do
    expected_result = ['Abercrombie', 'Giorgio Armani', 'J.crew', 'Fox']

    # ----------------------- Using Ruby -------------------------
    # names = Order.last.items.all.map(&:name)
    # names.sort_by! do |x| x[/\d+/].to_i end
    # ------------------------------------------------------------
# Select items.name from items join order_items on items.id = order_items.item_id where order_items.order_id = 12;

    # ------------------ Using ActiveRecord ----------------------
    names =  Order.last.items.pluck(:name)
    # ------------------------------------------------------------

    # Expectation
    expect(names).to eq(expected_result)
  end

  xit '18. returns the names of items for a users order' do
    expected_result = ['Giorgio Armani', 'Banana Republic', 'Izod', 'Fox']

    # ----------------------- Using Ruby -------------------------
    # items_for_user_3_third_order = []
    # grouped_orders = []
    # Order.all.each do |order|
    #   if order.items
    #     grouped_orders << order if order.user_id == @user_3.id
    #   end
    # end
    # grouped_orders.each_with_index do |order, idx|
    #   items_for_user_3_third_order = order.items.map(&:name) if idx == 2
    # end
    # ------------------------------------------------------------

      items_for_user_3_third_order = Order.where(user_id: @user_3.id).third.items.pluck(:name)
    # ------------------ Using ActiveRecord ----------------------

    # ------------------------------------------------------------

    # Expectation
    expect(items_for_user_3_third_order).to eq(expected_result)
  end

  xit '19. returns the average amount for all orders' do
    # ---------------------- Using Ruby -------------------------
    # average = (Order.all.map(&:amount).inject(:+)) / (Order.count)
    # -----------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    average = Order.average(:amount)
    # ------------------------------------------------------------

    # Expectation
    expect(average).to eq(650)
  end

  xit '20. returns the average amount for all orders for one user' do
    # ---------------------- Using Ruby -------------------------
    # orders = Order.all.map do |order|
    #   order if order.user_id == @user_3.id
    # end.select{|i| !i.nil?}
    #
    # average = (orders.map(&:amount).inject(:+)) / (orders.count)
    # -----------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    average = Order.where(user_id: @user_3.id).average(:amount)
    # ------------------------------------------------------------

    # Expectation
    expect(average.to_i).to eq(749)
  end
end
