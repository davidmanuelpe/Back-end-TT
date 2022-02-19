require 'rails_helper'

describe 'Authentication', type: :request do
    describe 'POST /authenticate' do

        let(:user) { FactoryBot.create(:user, nome: 'David5', email: 'david5@gmail.com', cpf: "374.845.411-25", password: '1234567' )}
        
        it 'autentica o usuario' do
            post '/api/v1/authenticate', params: { cpf: user.cpf, password: user.password}

            expect(response).to have_http_status(:created)
            expect(response_body).to eq({
                'token' => 'eyJhbGciOiJIUzI1NiJ9.eyJjaGF2ZSI6IjM3NC44NDUuNDExLTI1IC0gZGF2aWQ1QGdtYWlsLmNvbSJ9.hsjjR6YQz0SqfXJI-w9r1PVMH_4eFdGDaCMDB33Y5C8'
            })
        end

        it 'retorna erro se o cpf estiver em branco' do
            post '/api/v1/authenticate', params: { password: '1234567' }
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq({
                'error' => 'param is missing or the value is empty: cpf'
            })
        end

        it 'retorna erro se a password estiver em branco' do
            post '/api/v1/authenticate', params: { cpf: '374.845.411-25'}
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq({
                'error' => 'param is missing or the value is empty: password'
            })
        end

        it 'retorna um erro quando o password é incorreto' do
            post '/api/v1/authenticate', params: { cpf: user.cpf, password: 'dasdasd'}

            expect(response).to have_http_status(:unauthorized)
        end

    end

    

end