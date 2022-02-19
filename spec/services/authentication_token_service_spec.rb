require 'rails_helper'

describe AuthenticationTokenService do
    describe '.call' do
        let(:token) {described_class.encode(1)}
        it 'retorna um token de autenticação' do
                decoded_token = JWT.decode(
                    token, 
                    described_class::HMAC_SECRET, 
                    true, 
                    { algorithm: described_class::TIPO_DE_ALGORITMO }
                )
                
                expect(decoded_token).to eq(
                    [
                        {"chave"=>1},
                        {"alg"=>"HS256"}
                    ]
                )
        end
    end    
end