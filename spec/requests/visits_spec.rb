require 'rails_helper'


RSpec.describe "/visits", type: :request do

  let!(:user5) {FactoryBot.create(:user, nome: 'David5', password: '123456789', email: 'davidese3@gmail.com', cpf: '352.418.274-71')}
  #Autenticando token no sistema
  before do  
    allow(AuthenticationTokenService).to receive(:decode).and_return(user5.cpf + " - " + user5.email)
  end

  let!(:visit1) {FactoryBot.create(:visit, data: "2023-10-12", status: "pendente", checkin_at: "nil", checkout_at: "nil", user_id: user5.id)}
  let!(:visit2) {FactoryBot.create(:visit, data: "2023-09-10", status: "pendente", checkin_at: "nil", checkout_at: "nil", user_id: user5.id)}
  
  

  describe "GET /visits" do
    it 'listar visitas' do
      get '/api/v1/visits'
        expect(response).to have_http_status(:ok)
        expect(response_body.size).to eq(2)
        expect(response_body).to eq(
          [
            {
              "checkin_at"=>nil,
              "checkout_at"=>nil,
              "data"=>"2023-10-12",
              "nome_usuario"=>"#{visit1.user.nome}",
              "status"=>"pendente"
            },
            {
              "checkin_at"=>nil,
              "checkout_at"=>nil,
              "data"=>"2023-09-10",
              "nome_usuario"=>"#{visit2.user.nome}",
              "status"=>"pendente"
            }
          ]
        )
    end
  it "lista um subgrupo de visitas baseado no limite" do
    get '/api/v1/visits', params: { limit: 1}

    expect(response).to have_http_status(:success)
    expect(response_body.size).to eq(1)
    expect(response_body).to eq(
      [
        {
          "checkin_at"=>nil,
          "checkout_at"=>nil,
          "data"=>"2023-10-12",
          "nome_usuario"=>"#{visit1.user.nome}",
          "status"=>"pendente"
        }
      ]
    )

  end

  it "lista um subgrupo de visitas baseado no limite e no offset" do
    get '/api/v1/visits', params: { limit: 1, offset: 1}
    expect(response).to have_http_status(:success)
    expect(response_body.size).to eq(1)
    expect(response_body).to eq(
      [
        {
          "checkin_at"=>nil,
          "checkout_at"=>nil,
          "data"=>"2023-09-10",
          "nome_usuario"=>"#{visit2.user.nome}",
          "status"=>"pendente"
        }
      ]
    )

  end
  it "tem um limite máximo de 100 respostas por pesquisa" do
    #para evitar causar congestionamento de consultas e deixar o sistema lento
    expect(Visit).to receive(:limit).with(100).and_call_original
    get '/api/v1/visits', params: { limit: 999 }
  end  
end


  describe "POST /visits" do
    context "com parâmetros válidos" do
      it "cria uma nova visita" do
        expect{
          post '/api/v1/visits', params: 
          { visit: 
          { data: "2023-08-02", status: "pendente", checkin_at: "nil", checkout_at: "nil", user_id: user5.id }
          }
        }.to change { Visit.count}.from(2).to(3)
        visit3 = Visit.find(3)
        expect(response).to have_http_status(:created)
        expect(response_body).to eq(
          {
            "checkin_at"=>nil,
            "checkout_at"=>nil,
            "data"=>"2023-08-02",
            "nome_usuario"=>"#{visit3.user.nome}",
            "status"=>"pendente"
          }
        )
      end
  end

  context "com parâmetros inválidos" do
    it "não cria visita sem data" do
      expect{
        post '/api/v1/visits', params: 
        { visit: 
        { data: "", status: "pendente", checkin_at: "nil", checkout_at: "nil", user_id: user5.id }
        }
      }.to change { Visit.count}.by(0)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq(
        {
          "data"=>["não pode ser vazio"]
        }

      )
    end

    it "não cria visita com data menor que a atual" do
      expect{
        post '/api/v1/visits', params: 
        { visit: 
        { data: "2021-10-10", status: "pendente", checkin_at: "nil", checkout_at: "nil", user_id: user5.id }
        }
      }.to change { Visit.count}.by(0)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq(
        {
          "data"=>["tem que ser após a data de hoje"]
        }

      )
    end

    it "não cria visita sem status" do
      expect{
        post '/api/v1/visits', params: 
        { visit: 
        { data: "2022-10-10", status: "", checkin_at: "nil", checkout_at: "nil", user_id: user5.id }
        }
      }.to change { Visit.count}.by(0)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq(
        {
          "status"=>["não pode ser vazio"]
        }

      )
    end

    it "não cria visita com checkin maior que a data atual" do
      expect{
        post '/api/v1/visits', params: 
        { visit: 
        { data: "2022-10-10", status: "pendente", checkin_at: "2022-10-10", checkout_at: "nil", user_id: user5.id }
        }
      }.to change { Visit.count}.by(0)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq(
        {
          "checkin_at"=>["tem que ser menor que a data atual"]
        }

      )
    end

    it "não cria visita com checkin maior que checkout" do
      expect{
        post '/api/v1/visits', params: 
        { visit: 
        { data: "2022-10-10", status: "pendente", checkin_at: "2021-10-10", checkout_at: "2021-10-09", user_id: user5.id }
        }
      }.to change { Visit.count}.by(0)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq(
        {
          "checkin_at" => ["não pode ser maior que a data de checkout"],
          "checkout_at" => ["não pode ser menor que a data de checkin"]
        }

      )
    end

    it "não cria visita com checkout menor que checkin" do
      expect{
        post '/api/v1/visits', params: 
        { visit: 
        { data: "2022-10-10", status: "pendente", checkin_at: "2021-10-10", checkout_at: "2021-10-09", user_id: user5.id }
        }
      }.to change { Visit.count}.by(0)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq(
        {
          "checkin_at" => ["não pode ser maior que a data de checkout"],
          "checkout_at" => ["não pode ser menor que a data de checkin"]
        }

      )
    end

    it "não cria visita com usuário inexistente" do
      expect{
        post '/api/v1/visits', params: 
        { visit: 
        { data: "2022-10-10", status: "pendente", checkin_at: nil, checkout_at: nil, user_id: 888 }
        }
      }.to change { Visit.count}.by(0)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq(
        {
            "user" => ["must exist"],
            "user_id" => ["é inválido"],
        }

      )
    end

end
end


  describe "PUT /visits/:id" do
    context "com parâmetros válidos" do
      it "edita uma visita" do
          patch "/api/v1/visits/#{visit2.id}", params: 
          { visit: 
          { data: "2023-08-02", status: "realizado", checkin_at: "nil", checkout_at: "nil", user_id: user5.id }
          }
          expect(response).to have_http_status(:accepted)
          expect(response_body).to eq(
            {
              "checkin_at"=>nil,
              "checkout_at"=>nil,
              "data"=>"2023-08-02",
              "nome_usuario"=>"#{visit2.user.nome}",
              "status"=>"realizado"
            }
        )
      end
    end

    context "com parâmetros inválidos" do
      it "não edita visita sem data" do
          patch "/api/v1/visits/#{visit2.id}", params: 
          { visit: 
          { data: "", status: "realizado", checkin_at: "nil", checkout_at: "nil", user_id: user5.id }
          }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response_body).to eq(
            {
              "data" => ["não pode ser vazio"]
            }
        )
      end
      it "não edita visita com data menor que a data atual" do
          patch "/api/v1/visits/#{visit2.id}", params: 
          { visit: 
          { data: "2021-10-12", status: "realizado", checkin_at: "nil", checkout_at: "nil", user_id: user5.id }
          }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response_body).to eq(
            {
              "data" => ["tem que ser após a data de hoje"]
            }
        )
      end
      it "não edita visita sem status" do
        patch "/api/v1/visits/#{visit2.id}", params: 
        { visit: 
        { data: "2023-10-12", status: "", checkin_at: "nil", checkout_at: "nil", user_id: user5.id }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq(
          {
            "status" => ["não pode ser vazio"]
          }
      )
      end
      it "não edita visita com checkin maior que a data atual" do
        patch "/api/v1/visits/#{visit2.id}", params: 
        { visit: 
        { data: "2023-10-12", status: "pendente", checkin_at: "2023-09-08", checkout_at: "nil", user_id: user5.id }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq(
          {
            "checkin_at" => ["tem que ser menor que a data atual"]
          }
      )
      end

      it "não edita visita com checkin maior que o checkout" do
        patch "/api/v1/visits/#{visit2.id}", params: 
        { visit: 
        { data: "2023-10-12", status: "pendente", checkin_at: "2021-09-08", checkout_at: "2020-10-10", user_id: user5.id }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq(
          {
            "checkin_at" => ["não pode ser maior que a data de checkout"],
            "checkout_at" => ["não pode ser menor que a data de checkin"]
          }
      )
      end

      it "não edita visita com checkout menor que o checkin" do
        patch "/api/v1/visits/#{visit2.id}", params: 
        { visit: 
        { data: "2023-10-12", status: "pendente", checkin_at: "2021-09-08", checkout_at: "2020-10-10", user_id: user5.id }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq(
          {
            "checkin_at" => ["não pode ser maior que a data de checkout"],
            "checkout_at" => ["não pode ser menor que a data de checkin"]
          }
      )
      end

      it "não edita visita sem id de usuário" do
        patch "/api/v1/visits/#{visit2.id}", params: 
        { visit: 
        { data: "2023-10-12", status: "pendente", checkin_at: nil, checkout_at: nil, user_id: 568 }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq(
          {
            "user" => ["must exist"],
            "user_id" => ["é inválido"]
          }
      )
      end

    end
  end


  describe "DELETE /visits/:id" do
    it "deleta uma visita" do
      delete "/api/v1/visits/#{visit2.id}"

      expect(response).to have_http_status(:no_content)
    end
  end
end
