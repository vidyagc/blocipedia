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
     description: "Premium Membership - #{current_user.email}", 
     amount: Amount.default
   }
  end 
 end
 
 def create

# It's creating a stripe customer, the Stripe::Customer.create code is a call to the stripe gem. Here it's passing the customer's email address and the stripeToken in as arguments.
# Then it calls the Charge module, passing in a number of attributes that we want to pass to Stripe's API.
# Lastly it catches any errors and redirect the user to the new path if any errors occur.

   customer = Stripe::Customer.create(
     email: current_user.email,
     card: params[:stripeToken]
   )
 
   charge = Stripe::Charge.create(
     customer: customer.id, 
     amount: Amount.default,
     description: "Premium Membership - #{current_user.email}",
     currency: 'usd'
   )
 
   
 
   current_user.update_role('premium', customer.id)
   
   flash[:notice] = "Thank you for your payment of #{view_context.number_to_currency(charge.amount/100)}, #{current_user.email}. You can begin creating private Wikis!"
   redirect_to account_management_path 
 
   rescue Stripe::CardError => e
     flash[:alert] = e.message
     redirect_to new_charge_path
 end
 
 def destroy
  if current_user.role == 'standard'
    flash[:alert] = "You already have a Standard account."
    redirect_to account_management_path 
  else 
    cu = Stripe::Customer.retrieve(current_user.cid)
    cu.delete
    current_user.update_role('standard', nil)
    flash[:notice] = "#{current_user.email}, your Premium account has been downgraded back to a Standard account."
    redirect_to account_management_path 
   end 
 end 
 
end
