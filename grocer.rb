require 'pry'

CLEARANCE_ITEM_DISCOUNT_RATE = 0.20
BIG_PURCHASE_DISCOUNT_RATE = 0.10


def find_item_by_name_in_collection(name, collection)
  # Implement me first!
  #
  # Consult README for inputs and outputs
  collection.find do |item|
    item[:item] == name
  end
end

def consolidate_cart(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
  return_cart_array = []
  cart.each do |item|
    found_item = find_item_by_name_in_collection(item[:item], return_cart_array)
    if found_item
      item[:count] += 1
    else
      item[:count] = 1
      return_cart_array << item
    end
  end
  return_cart_array
end

def apply_coupons(cart, coupons)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  i = 0
  while i < coupons.length do
    coupon = coupons[i]
    item_with_coupon = find_item_by_name_in_collection(coupon[:item], cart)
    item_is_in_basket = !!item_with_coupon
    count_is_big_enough_to_apply = item_is_in_basket && item_with_coupon[:count] >= coupon[:num]
    if item_is_in_basket && count_is_big_enough_to_apply
      apply_coupon_to_cart_helper_method(item_with_coupon, coupon, cart)
    end
    i += 1
  end
  cart
end

def apply_coupon_to_cart_helper_method(matching_item, coupon, cart)
  matching_item[:count] -= coupon[:num]
  item_with_coupon = make_a_new_item_hash_helper_method(coupon)
  item_with_coupon[:clearance] = matching_item[:clearance]
  cart << item_with_coupon
end

def make_a_new_item_hash_helper_method(coupon)
  new_price = (coupon[:cost].to_f/coupon[:num]).round(2)
  {
    :item => "#{coupon[:item]} W/COUPON",
    :price => new_price,
    :count => coupon[:num]
  }
end


def apply_clearance(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  cart.map do |item_in_cart|
    if item_in_cart[:clearance] == true
      item_in_cart[:price] = (item_in_cart[:price] * (1-CLEARANCE_ITEM_DISCOUNT_RATE)).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers
  consolidated_cart = consolidate_cart(cart)
  apply_coupons(consolidated_cart, coupons)
  apply_clearance(consolidated_cart)
  total = 0
  consolidated_cart.each do |item|
    total += total_cost_helper_method(item)
  end
  total > 100.0 ? total * (1.0-BIG_PURCHASE_DISCOUNT_RATE) :total
end

def total_cost_helper_method(item)
  item[:price] * item[:count]
end
