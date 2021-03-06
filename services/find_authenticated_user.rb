require 'http'

# Returns an authenticated user, or nil
class FindAuthenticatedUser
  def self.call(username:, password:)
    response = HTTP.post("#{ENV['API_HOST']}/users/authenticate",
                         json: {username: username, password: password})
    response.code == 200 ? JSON.parse({ :data => JSON.parse(response) }.to_json) : nil
  end
end
