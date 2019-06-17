module ControllerMacros
  def get_auth_params_from_login_response_headers(response)
    client = response.headers["client"]
    token = response.headers['access-token']
    expiry = response.headers['expiry']
    token_type = response.headers['token-type']  
    uid =   response.headers['uid']  
    content_type = response.headers['content-type']

    auth_params = {
                    'access-token' => token,
                    'client' => client,
                    'uid' => uid,
                    'expiry' => expiry,
                    'token_type' => token_type,
                    'content_type' => content_type
                  }
    auth_params
  end

  def create_auth_header_from_scratch(user1)
    @current_user = user1      
    client_id = SecureRandom.urlsafe_base64(nil, false)
    token     = SecureRandom.urlsafe_base64(nil, false)

    @current_user.tokens[client_id] = {
    token: BCrypt::Password.create(token),
    expiry: (Time.now + 1.day).to_i
    }
    new_auth_header = @current_user.build_auth_header(token, client_id)

  end


  def login(user)
    post '/auth/sign_in', params:  { email: user.email, password: user.password}.to_json,
                    headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end 
  
  def reg(user)
    post '/auth', params:  { email: user.email, password: user.password }.to_json,
                    headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  def sign_up(user)

    females = ["elizabeth", "rose", "juliet"]
    surnameFemales = ["rosewelth", "gates", "jobs"]
    providers = ["gmail.com", "hotmail.com", "yahoo.com", "mail.ru"]
    
    post '/auth', params:  { email: "#{females.sample}.#{surnameFemales.sample}#{rand(252...4350)}@#{providers.sample}", password: user.password}.to_json,
                    headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end 
end
