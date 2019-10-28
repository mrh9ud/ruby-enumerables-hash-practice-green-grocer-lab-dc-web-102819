def consolidate_cart(cart)
  key_array = []
  cart.map {|outer_hash| outer_hash.each_key {|key| key_array.push(key)}}
  new_hash = Hash[*cart.collect{|h| h.to_a}.flatten]
  key_array.each do |value|
    new_hash[value][:count] = 0
  end
  key_array.each do |value|
    new_hash[value][:count] += 1
  end
  return new_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.keys.include?(coupon[:item])
      if cart[coupon[:item]][:count] >= coupon[:num]
        itemwithCoupon = "#{coupon[:item]} W/COUPON"
        if cart[itemwithCoupon]
          cart[itemwithCoupon][:count] += coupon[:num]
          cart[coupon[:item]][:count] -= coupon[:num]
        else
          cart[itemwithCoupon] = {}
          cart[itemwithCoupon][:price] = (coupon[:cost] / coupon[:num])
          cart[itemwithCoupon][:clearance] = cart[coupon[:item]][:clearance]
          cart[itemwithCoupon][:count] = coupon[:num]
          cart[coupon[:item]][:count] -= coupon[:num]
        end
      end
    end
  end
  cart


  
coupon_hash = Hash.new
  coupons.each do |coupon_block|
  
    if cart[coupon_block[:item]][:count] >= coupon_block[:num]
      item_with_coupon = "#{coupon_block[:item]} W/COUPON"
      cart[coupon_block[:item]][:count] -= coupon_block[:num]
    end
    if cart[coupon_block[:item]]
      cart[coupon_block[:item]][:count] += coupon_block[:num]
    else
      cart[coupon_block[:item]] = {:price => (coupon_block[:cost]/coupon_block[:num]), :clearance => cart[coupon_block[:item]][:clearance], :count => coupon_block[:num]}
    end
  end

  p cart
end

def apply_clearance(cart)
  cart.each do |item_name, item_data|
    if item_data[:clearance]
      item_data[:price] = (item_data[:price] * 0.8).round(2)
    end
  end
end

def checkout(cart, coupons)
  cart_hash = consolidate_cart(cart)
  cart_hash = apply_coupons(cart_hash, coupons)
  cart_hash = apply_clearance(cart_hash)
  
  cart_sum = 0
  cart_hash.each do |item_name, item_data|
    cart_sum += item_data[:price] * item_data[:count]
  end
  if cart_sum > 100
    cart_sum = cart_sum * 0.9
  end
  p cart_sum
end
