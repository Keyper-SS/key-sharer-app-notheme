require 'sinatra'
require 'rack-flash'
require 'rack/ssl-enforcer'

# Base class for ConfigShare Web Application
class KeySharerApp < Sinatra::Base
  enable :logging

  use Rack::Session::Cookie, secret: ENV['MSG_KEY'],
                             expire_after: 60 * 60 * 24 * 7
  use Rack::Flash

  configure :production do
    use Rack::SslEnforcer
  end

  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, File.expand_path('../../public', __FILE__)

  before do
    if session[:current_user]
      @current_user = SecureMessage.decrypt(session[:current_user])
    end
  end

  get '/' do
    slim :home
  end
end
