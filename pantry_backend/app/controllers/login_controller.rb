require 'uri'
require 'net/http'

# Controller to handle login requests
class LoginController < ApplicationController
  def create
    login_params_hash = login_params.to_h
    email = login_params_hash[:email]
    pass = login_params_hash[:password]

    # Setup for using OAuth service using API call
    form_data = {
      'email' => email,
      'password' => pass
    }
    uri = URI('http://localhost:3001/api/v1/authenticate/login')
    res = Net::HTTP.post_form(uri, form_data)

    # Set token into cookie for frontend
    details = JSON.parse(res.body)
    details['token']
    response.set_cookie(
      :jwt,
      {
        value: details['token'],
        httponly: true
      }
    )

    # Create data for the logged in user
    details['expireAt'] = Time.now + details['expiry'].seconds
    details.delete('expiry')
    details['employee_id'] = details.delete 'user_id'

    # Add user details to database
    user = User.find_by_employee_id(details['employee_id'])
    if user.blank?
      user = User.new(details)
    else
      user.update(details)
    end

    render json: user, status: :created
  end

  private

  # function to permit parameters for login
  def login_params
    params.require(:login).permit(:email, :password)
  end
end
