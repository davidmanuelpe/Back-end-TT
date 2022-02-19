class AuthenticationTokenService
    HMAC_SECRET = 'my$ecretK3y'
    TIPO_DE_ALGORITMO = 'HS256'

    def self.encode(user_id)
        payload = {chave: user_id}

        token = JWT.encode payload, HMAC_SECRET, TIPO_DE_ALGORITMO
    end

    def self.decode(token)
        decode_token = JWT.decode token, HMAC_SECRET, true, { algorith: TIPO_DE_ALGORITMO}
        decode_token[0]['chave']
    end
end