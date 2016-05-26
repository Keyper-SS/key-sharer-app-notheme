require 'http'

# Returns all projects belonging to an account
class GetReceivedSecrets
  def self.call(current_user:, auth_token:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .get("#{ENV['API_HOST']}/users/#{current_user['id']}/received_secrets")
    response.code == 200 ? extract_received_secrets(JSON.parse({ :data => JSON.parse(response) }.to_json)) : nil
  end

  private

  def self.extract_received_secrets(received_secrets)
    received_secrets['data']['data'].map do |received|
      { title: received['data']['title'],
        description: received['data']['description'],
        account_encrypted: received['data']['account_encrypted'] }
    end
  end
end
