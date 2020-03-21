require 'jwt'

module JsonWebToken
  PRIVATE_KEY = OpenSSL::PKey::RSA.generate(2048)
  PUBLIC_KEY = PRIVATE_KEY.public_key

  def jwt_authenticate
    if request.headers['Authorization'].blank?
      render status: 400, json: {status: 400, msg: "Missing Authorization parameter."}
    else
      encode_token = request.headers['Authorization'].split('Bearer ').last
      begin
        pay_load = decode(encode_token)
        @current_user = User.find_by(id: pay_load['user_id'])
        if @current_user.blank?
          render status: 401, json: {status: 404, msg: "Con't find your account."}
        else
          @current_user
        end
      rescue => ex
        render statue: 401, json: {statue: 401, msg: "Invalid Access Token."}
      end
    end
  end

  def encode(user_id, exp=1.day.from_now.to_i)
    pay_load = {user_id: user_id, exp: exp}
    JWT.encode(pay_load, PRIVATE_KEY, 'RS256')
  end

  def decode(token)
    decode_jwt = JWT.decode(token, PUBLIC_KEY, true, {algorithm: 'RS256'})
    decode_jwt.first
  end

end
