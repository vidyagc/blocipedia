require 'amount'

class ChargesController < ApplicationController

before_action :authenticate_user!, except: [:account]

 def new
  
  if current_user.role == 'premium'
    flash[:alert] = "You already have a Premium account. If you are unable to create private Wikis, please contact customer support."
    redirect_to users_show_path 
  
  else 
   @stripe_btn_data = {
     key: "#{ Rails.configuration.stripe[:publishable_key] }",
     description: "BigMoney Membership - #{current_user.email}", # EDIT 1S7 - was current_user.name
     amount: Amount.default 
   }
  end 
 end
 
 def create
   # Creates a Stripe Customer object, for associating
   # with the charge
   customer = Stripe::Customer.create(
     email: current_user.email,
     card: params[:stripeToken]
   )
 
   # Where the real magic happens
   charge = Stripe::Charge.create(
     customer: customer.id, # Note -- this is NOT the user_id in your app
     amount: Amount.default,
     description: "BigMoney Membership - #{current_user.email}",
     currency: 'usd'
   )
 
   current_user.update_role('premium', customer.id)
   
   flash[:notice] = "Thank you for your payment of #{view_context.number_to_currency(charge.amount/100)}, #{current_user.email}. You can begin creating private Wikis!"
   redirect_to users_show_path 
 
   # Stripe will send back CardErrors, with friendly messages
   # when something goes wrong.
   # This `rescue block` catches and displays those errors.
   rescue Stripe::CardError => e
     flash[:alert] = e.message
     redirect_to new_charge_path
 end
 
 def destroy
  if current_user.role == 'standard'
    flash[:alert] = "You already have a Standard account."
    redirect_to users_show_path # EDIT 1S7 - old path listed here was 'user_path(current_user) # or wherever'
  else 
    cu = Stripe::Customer.retrieve(current_user.cid)
    cu.delete
    current_user.update_role('standard', nil)
    flash[:notice] = "#{current_user.email}, your Premium account has been downgraded back to a Standard account."
    redirect_to users_show_path # EDIT 1S7 - old path listed here was 'user_path(current_user) # or wherever'
   end 
 end 
 
end
