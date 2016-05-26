require 'http'

# Returns all projects belonging to an account
class GetOwnedSecrets
  def self.call(current_user:, auth_token:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .get("#{ENV['API_HOST']}/users/#{current_user['id']}/owned_secrets")
    response.code == 200 ? extract_owned_secrets(JSON.parse({ :data => JSON.parse(response) }.to_json)) : nil
  end

  private

  def self.extract_owned_secrets(owned_secrets)
    owned_secrets['data']['data'].map do |owned|
      { title: owned['data']['title'],
        description: owned['data']['description'],
        account_encrypted: owned['data']['account_encrypted'] }
    end
  end
end
