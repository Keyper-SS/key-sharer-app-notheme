require 'sinatra'

# Base class for SharerKey Web Application
class KeySharerApp < Sinatra::Base
  get '/user/:username' do
    if @current_user && @current_user['attributes']['username'] == params[:username]
      @auth_token = session[:auth_token]
      slim(:user)
    else
      slim(:login)
    end
  end

  get '/login/?' do
    slim :login
  end

  post '/login/?' do
    credentials = LoginCredentials.call(params)
    if credentials.failure?
      flash[:error] = 'Please enter both your username and password'
      redirect '/login'
      halt
    end

    auth_user = FindAuthenticatedUser.call(credentials)

    if auth_user
      @current_user = auth_user['data']['user']
      session[:auth_token] = auth_user['data']['auth_token']
      session[:current_user] = SecureMessage.encrypt(@current_user)
      flash[:notice] = "Welcome back #{@current_user['attributes']['username']}"
      redirect '/'
    else
      flash[:error] = 'Your username or password did not match our records'
      slim :login
    end
  end

  get '/logout/?' do
    @current_user = nil
    session.clear
    flash[:notice] = 'You have logged out - please login again to use this site'
    slim :login
  end
end
