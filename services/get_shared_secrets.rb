require 'http'

# Returns all projects belonging to an account
class GetSharedSecrets
  def self.call(current_user:, auth_token:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .get("#{ENV['API_HOST']}/users/#{current_user['id']}/shared_secrets")
    response.code == 200 ? extract_shared_secrets(JSON.parse({ :data => JSON.parse(response) }.to_json)) : nil
  end

  private

  def self.extract_shared_secrets(shared_secrets)
    shared_secrets['data']['data'].map do |shared|
      { title: shared['data']['title'],
        description: shared['data']['description'],
        account_encrypted: shared['data']['account_encrypted'] }
    end
  end
end
