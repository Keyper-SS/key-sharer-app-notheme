require 'sinatra'

# Base class for KeySharerApp Web Application
class KeySharerApp < Sinatra::Base
  get '/user/:username/owned_secrets' do
    if @current_user && @current_user['attributes']['username'] == params[:username]
       @owned_secrets = GetOwnedSecrets.call(current_user: @current_user,
                                             auth_token: session[:auth_token])
    end

    @owned_secrets ? slim(:all_owned_secrets) : redirect('/login')
  end

  get '/user/:username/shared_secrets' do
    if @current_user && @current_user['attributes']['username'] == params[:username]
       @shared_secrets = GetSharedSecrets.call(current_user: @current_user,
                                               auth_token: session[:auth_token])
    end

    @shared_secrets ? slim(:all_shared_secrets) : redirect('/login')
  end

  get '/user/:username/received_secrets' do
    if @current_user && @current_user['attributes']['username'] == params[:username]
       @received_secrets = GetReceivedSecrets.call(current_user: @current_user,
                                                   auth_token: session[:auth_token])
    end

    @received_secrets ? slim(:all_received_secrets) : redirect('/login')
  end
end
