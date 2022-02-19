require 'rails_helper'

RSpec.describe "Users", type: :request do


  FactoryBot.create(:user, nome: 'David', password: '12345678', email: 'david@gmail.com', cpf: '667.579.778-69')
  FactoryBot.create(:user, nome: 'David2', password: '12345678', email: 'davide@gmail.com', cpf: '427.223.514-12')
  FactoryBot.create(:user, nome: 'David4', password: '123456789', email: 'davidese@gmail.com', cpf: '549.371.584-81')
  let!(:user4) {FactoryBot.create(:user, nome: 'David5', password: '123456789', email: 'davidese2@gmail.com', cpf: '785.888.657-69')}

  before do  
    allow(AuthenticationTokenService).to receive(:decode).and_return(user4.cpf + " - " + user4.email)
  end

  describe "GET /users" do
    it 'listar usuários' do
      get '/api/v1/users'

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(4)
      expect(response_body).to eq(
        [
          {
            'id' => 1,
            'nome' => 'David',
            'email' => 'david@gmail.com',
            'cpf' => '667.579.778-69'
          },
          {
            'id' => 2,
            'nome' => 'David2',
            'email' => 'davide@gmail.com',
            'cpf' => '427.223.514-12'
          },
          {
            'id' => 3,
            'nome' => 'David4',
            'email' => 'davidese@gmail.com',
            'cpf' => '549.371.584-81'
          },
          {
            'id' => 4,
            'nome' => 'David5',
            'email' => 'davidese2@gmail.com',
            'cpf' => '785.888.657-69'
          }
        ]
      )
    end
    it "lista um subgrupo de usuários baseado no limite" do
      get '/api/v1/users', params: { limit: 2}

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(2)
      expect(response_body).to eq(
        [
          {
            'id' => 1,
            'nome' => 'David',
            'email' => 'david@gmail.com',
            'cpf' => '667.579.778-69'
          },
          {
            'id' => 2,
            'nome' => 'David2',
            'email' => 'davide@gmail.com',
            'cpf' => '427.223.514-12'
          }
        ]
      )

    end
    it "lista um subgrupo de usuários baseado no limite e no offset" do
      get '/api/v1/users', params: { limit: 1, offset: 2}
      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq(
        [
          {
            'id' => 3,
            'nome' => 'David4',
            'email' => 'davidese@gmail.com',
            'cpf' => '549.371.584-81'
          }
        ]
      )

    end
    it "tem um limite máximo de 100 respostas por pesquisa" do
      #para evitar causar congestionamento de consultas e deixar o sistema lento
      expect(User).to receive(:limit).with(100).and_call_original
      get '/api/v1/users', params: { limit: 999 }
    end  

  end

  describe "POST /users" do
    context "com parâmetros válidos" do
      it "cria um novo usuário" do
        expect{
          post '/api/v1/users', params: 
          { user: 
          { nome: 'Joao', password: '1234567', email: 'joao@gmail.com', cpf: '522.883.117-70' }
          }
        }.to change { User.count}.from(4).to(5)
        
        expect(response).to have_http_status(:created)
        expect(response_body).to eq(
          {
            'id' => 5,
            'nome' => 'Joao',
            'email' => 'joao@gmail.com',
            'cpf' => '522.883.117-70'
          }
        )
      end
    end
  


    context "com parâmetros inválidos" do
      it "não cria usuário sem nome" do
        expect {
          post '/api/v1/users', params: { user: { password: '1234567', email: 'joao@gmail.com', cpf: '522.883.117-70' }}
        }.to change(User, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "nome" => ["Não pode ser vazio"]
        })
      end

      it "não cria usuário sem password" do
        expect {
          post '/api/v1/users', params: { user: { nome: 'Joao', email: 'joao@gmail.com', cpf: '522.883.117-70' }}
        }.to change(User, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "password" => ["can't be blank", "Não pode ter menos do que 7 dígitos"]
        })
      end

      it "não cria usuário com password menor do que 7 dígitos" do
        expect {
          post '/api/v1/users', params: { user: { nome: 'Joao', password: '123456', email: 'joao@gmail.com', cpf: '522.883.117-70' }}
        }.to change(User, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "password" => ["Não pode ter menos do que 7 dígitos"]
        })
      end

      it "não cria usuário sem email" do
        expect {
          post '/api/v1/users', params: { user: { nome: 'Joao', password: '1234567', cpf: '522.883.117-70' }}
        }.to change(User, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "email" => ["Não pode ser vazio", "formato incorreto"]
        })
      end

      it "não cria usuário email com formato incorreto" do
        expect {
          post '/api/v1/users', params: { user: { nome: 'Joao', password: '1234567', email: 'joaogmail.com', cpf: '522.883.117-70' }}
        }.to change(User, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "email" => ["formato incorreto"]
        })
      end

      it "não cria usuário com email já existente (case_sensitive)" do
        # Usuário criado no factorybot
        expect {
          post '/api/v1/users', params: { user: { nome: 'Joao', password: '1234567', email: 'Davidese@gmail.com', cpf: '522.883.117-70' }}
        }.to change(User, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "email" => ["já cadastrado"]
        })
      end

      it "não cria usuário sem cpf" do
        expect{
          post '/api/v1/users', params: { user: { nome: 'Joao', password: '1234567', email: 'joao@gmail.com'}}
        }.to change(User, :count).by(0)
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "cpf" => ["Não pode ser vazio", "Inválido, deve ser no formato: 999.999.999-99", "Deve ter exatamente 14 dígitos"]
        })
      end

      it "não cria usuário com cpf com uma quantidade diferente de 14 dígitos" do
        expect{
          post '/api/v1/users', params: { user: { nome: 'Joao', password: '1234567', email: 'joao@gmail.com', cpf: '522.883.117-7' }}
        }.to change(User, :count).by(0)
        
        expect(response).to have_http_status(:unprocessable_entity)

        expect(response_body).to eq({
          "cpf" => ["Inválido, deve ser no formato: 999.999.999-99", "Deve ter exatamente 14 dígitos"]
        })

        expect{
          post '/api/v1/users', params: { user: { nome: 'Joao', password: '1234567', email: 'joao@gmail.com', cpf: '522.883.117--70' }}
        }.to change(User, :count).by(0)
        
        expect(response).to have_http_status(:unprocessable_entity)

        expect(response_body).to eq({
          "cpf" => ["Inválido, deve ser no formato: 999.999.999-99", "Deve ter exatamente 14 dígitos"]
        })
      end

      it "não cria usuário com cpf em formato diferente de 999.999.999-99" do
        expect{
          post '/api/v1/users', params: { user: { nome: 'Joao', password: '1234567', email: 'joao@gmail.com', cpf: '52288311770' }}
        }.to change(User, :count).by(0)
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "cpf" => ["Inválido, deve ser no formato: 999.999.999-99", "Deve ter exatamente 14 dígitos"]
        })
      end

      it "não cria usuário com cpf inválido" do
        expect{
          post '/api/v1/users', params: { user: { nome: 'Joao', password: '1234567', email: 'joao@gmail.com', cpf: '522.883.117-80' }}
        }.to change(User, :count).by(0)
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "cpf" => ["é inválido"]
        })
      end

      it "não cria usuário com cpf já existente" do
        # Usuário criado no factorybot
        expect {
          post '/api/v1/users', params: { user: { nome: 'Joao', password: '1234567', email: 'joao@gmail.com', cpf: '549.371.584-81' }}
        }.to change(User, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "cpf" => ["já cadastrado"]
        })
      end



    end
  end

  describe "PUT /users/:id" do
    let!(:user3) {FactoryBot.create(:user, nome: 'David3', password: '12345678', email: 'davides@gmail.com', cpf: '598.351.523-30')}
    context "com parâmetros válidos" do
      it "edita um usuário" do
        patch "/api/v1/users/#{user3.id}", params: { user: { nome: 'David3', password: '12345678', email: 'davides1@gmail.com', cpf: '598.351.523-30'}}
        expect(response).to have_http_status(:accepted)
        expect(response_body).to include({
          "cpf" => "598.351.523-30",
          "email" => "davides1@gmail.com",
          "id" => 5,
          "nome" => "David3",       
      })
      end

    end
    context "com parâmetros inválidos" do
      it "não edita um usuário sem nome" do
        patch "/api/v1/users/#{user3.id}", params: { user: { nome: '', password: '12345678', email: 'davides1@gmail.com', cpf: '598.351.523-30'}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "nome" => ["Não pode ser vazio"]
        })
      end

      it "não edita um usuário sem password" do
        patch "/api/v1/users/#{user3.id}", params: { user: { nome: 'David3', password: '', email: 'davides1@gmail.com', cpf: '598.351.523-30'}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "password" => ["Não pode ter menos do que 7 dígitos"]
        })
      end

      it "não edita um usuário com password menor do que 7" do
        patch "/api/v1/users/#{user3.id}", params: { user: { nome: 'David3', password: '123456', email: 'davides1@gmail.com', cpf: '598.351.523-30'}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "password" => ["Não pode ter menos do que 7 dígitos"]
        })
      end

      it "não edita um usuário sem email" do
        patch "/api/v1/users/#{user3.id}", params: { user: { nome: 'David3', password: '1234567', email: '', cpf: '598.351.523-30'}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "email" => ["Não pode ser vazio", "formato incorreto"]
        })
      end

      it "não edita um usuário com formato de email inválido" do
        patch "/api/v1/users/#{user3.id}", params: { user: { nome: 'David3', password: '1234567', email: 'davides1gmail.com', cpf: '598.351.523-30'}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "email" => ["formato incorreto"]
        })
      end

      it "não edita um usuário com email existente" do
        # Usuário criado no factorybot
        patch "/api/v1/users/#{user3.id}", params: { user: { nome: 'David3', password: '1234567', email: 'davide@gmail.com', cpf: '598.351.523-30'}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "email" => ["já cadastrado"]
        })
      end

      it "não edita um usuário sem cpf" do
        patch "/api/v1/users/#{user3.id}", params: { user: { nome: 'David3', password: '1234567', email: 'davides1@gmail.com', cpf: ''}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "cpf" => ["Não pode ser vazio", "Inválido, deve ser no formato: 999.999.999-99", "Deve ter exatamente 14 dígitos"]
        })
      end

      it "não edita um usuário com cpf menor que 14 dígitos" do
        patch "/api/v1/users/#{user3.id}", params: { user: { nome: 'David3', password: '1234567', email: 'davides1@gmail.com', cpf: '598.351.523-3'}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "cpf" => ["Inválido, deve ser no formato: 999.999.999-99", "Deve ter exatamente 14 dígitos"]
        })
      end

      it "não edita um usuário com cpf maior que 14 dígitos" do
        patch "/api/v1/users/#{user3.id}", params: { user: { nome: 'David3', password: '1234567', email: 'davides1@gmail.com', cpf: '598.351.523-303'}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "cpf" => ["Inválido, deve ser no formato: 999.999.999-99", "Deve ter exatamente 14 dígitos"]
        })
      end

      it "não edita um usuário com formato de cpf inválido" do
        patch "/api/v1/users/#{user3.id}", params: { user: { nome: 'David3', password: '1234567', email: 'davides1@gmail.com', cpf: '59835152330'}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "cpf" => ["Inválido, deve ser no formato: 999.999.999-99", "Deve ter exatamente 14 dígitos"]
        })
      end

      it "não edita um usuário com cpf inválido" do
        patch "/api/v1/users/#{user3.id}", params: { user: { nome: 'David3', password: '1234567', email: 'davides1@gmail.com', cpf: '598.351.523-80'}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "cpf" => ["é inválido"]
        })
      end

      it "não edita um usuário com cpf já existente" do
        # Usuário criado no factorybot
        patch "/api/v1/users/#{user3.id}", params: { user: { nome: 'David3', password: '1234567', email: 'davides1@gmail.com', cpf: '427.223.514-12'}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({
          "cpf" => ["já cadastrado"]
        })
      end

    end
  end


  describe "DELETE /users/:id" do
    let!(:user3) {FactoryBot.create(:user, nome: 'David3', password: '12345678', email: 'davides@gmail.com', cpf: '598.351.523-30')}
    
    it "deleta um usuário" do
      delete "/api/v1/users/#{user3.id}"

      expect(response).to have_http_status(:no_content)
    end
  end
end
