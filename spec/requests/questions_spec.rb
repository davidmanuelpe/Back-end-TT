require 'rails_helper'

RSpec.describe "/questions", type: :request do

  #Autenticando token no sistema
  let!(:user5) {FactoryBot.create(:user, nome: 'David5', password: '123456789', email: 'davidese3@gmail.com', cpf: '352.418.274-71')}
  before do  
    allow(AuthenticationTokenService).to receive(:decode).and_return(user5.cpf + " - " + user5.email)
  end

  let!(:form1) {FactoryBot.create(:formulary, nome:"pesquisa1")}

  let!(:visit1) {FactoryBot.create(:visit, data: "2023-10-12", status: "pendente", checkin_at: "nil", checkout_at: "nil", user_id: user5.id)}

  let!(:pergunta1) {FactoryBot.create(:question, nome:"pergunta1", tipo_de_questao:"foto", formulary_id:form1.id)}

  let!(:pergunta2) {FactoryBot.create(:question, nome:"pergunta2", tipo_de_questao:"foto", formulary_id:form1.id)}

  let!(:resposta) {FactoryBot.create(:answer, content:"asdsafasfas", answered_at:"nil", formulary_id:form1.id, question_id:pergunta1.id, visit_id:visit1.id)}



  describe "GET /questions" do
    it 'listar perguntas' do
      get '/api/v1/questions'
        array_respostas_perguntas_1 = []
        resposta1 = []
        resposta1.append(resposta.content)
        resposta1.append(resposta.answered_at)
        array_respostas_perguntas_1.append(resposta1)
        expect(response).to have_http_status(:ok)
        expect(response_body.size).to eq(2)
        expect(response_body).to eq(
          [
            {
              "nome" => "pergunta1",
              "respostas" => array_respostas_perguntas_1,
              "tipo_de_questao"=>"foto"
            },
            {
              "nome" => "pergunta2",
              "respostas" => [],
              "tipo_de_questao" => "foto"
            }
          ]
        )
    end
    it "lista um subgrupo de perguntas baseado no limite" do
      get '/api/v1/questions', params: { limit: 1}
      array_respostas_perguntas_1 = []
      resposta1 = []
      resposta1.append(resposta.content)
      resposta1.append(resposta.answered_at)
      array_respostas_perguntas_1.append(resposta1)
      expect(response).to have_http_status(:ok)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq(
        [
          {
            "nome" => "pergunta1",
            "respostas" => array_respostas_perguntas_1,
            "tipo_de_questao"=>"foto"
          }
        ]
      )
    end
    it "lista um subgrupo de formulários baseado no limite e no offset" do
      get '/api/v1/questions', params: { limit: 1, offset: 1}
      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq(
        [
          {
            "nome" => "pergunta2",
            "respostas" => [],
            "tipo_de_questao" => "foto"
          }
        ]
      )
    end
    it "tem um limite máximo de 100 respostas por pesquisa" do
      #para evitar causar congestionamento de consultas e deixar o sistema lento
      expect(Question).to receive(:limit).with(100).and_call_original
      get '/api/v1/questions', params: { limit: 999 }
    end 
  end  
 



  describe "POST /questions" do
    context "com parâmetros válidos" do
      it "cria uma nova pergunta" do       
        expect{
          post '/api/v1/questions', params: 
          { question: 
          { nome:"pergunta4", tipo_de_questao:"texto", formulary_id:form1.id}
          }
        }.to change { Question.count}.from(2).to(3)
        expect(response).to have_http_status(:created)
        expect(response_body).to eq(
          {
            "nome" => "pergunta4",
            "respostas" => [],
            "tipo_de_questao" => "texto",
          }
        )
      end
    end

    context "com parâmetros inválidos" do
      it "não cria pergunta sem nome" do
        expect{
          post '/api/v1/questions', params: 
          { question: 
          { nome:"", tipo_de_questao:"texto", formulary_id:form1.id}
          }
        }.to change { Question.count}.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq(
          {
            "nome" => ["não pode ser vazio"]
          }
        )
      end


      it "não cria pergunta com nome duplicado no mesmo formulário" do
        expect{
          post '/api/v1/questions', params: 
          { question: 
          { nome:"pergunta1", tipo_de_questao:"texto", formulary_id:form1.id}
          }
        }.to change { Question.count}.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq(
          {
            "nome" => ["já cadastrada"]
          }
        )
      end

      it "não cria pergunta sem tipo de pergunta" do
        expect{
          post '/api/v1/questions', params: 
          { question: 
          { nome:"pergunta3", tipo_de_questao:"", formulary_id:form1.id}
          }
        }.to change { Question.count}.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq(
          {
            "tipo_de_questao" => ["não pode ser vazio"]
          }
        )
      end

      it "não cria pergunta sem id de formulário" do
        expect{
          post '/api/v1/questions', params: 
          { question: 
          { nome:"pergunta3", tipo_de_questao:"texto", formulary_id:''}
          }
        }.to change { Question.count}.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq(
          {
            "formulary" => ["must exist"]
          }
        )
      end

    end
  end
  describe "PUT /questions/:id" do
    context "com parâmetros válidos" do
      it "edita uma pergunta" do
        patch "/api/v1/questions/#{pergunta1.id}", params: 
        { question: 
        { nome: "pergunta8"}
        }
        expect(response).to have_http_status(:accepted)
        expect(response_body).to eq(
          {
            "nome" => "pergunta8",
            "respostas" => [["asdsafasfas", nil]],
            "tipo_de_questao" => "foto"
          }
        )
      end
    end
  
    context "com parâmetros inválidos" do
      it "não edita pergunta sem nome" do
        patch "/api/v1/questions/#{pergunta1.id}", params: 
        { question: 
        { nome: ""}
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq(
          {
            "nome" => ["não pode ser vazio"]
          }
        )
      end

      it "não edita pergunta com nome duplicado em formulário" do
        patch "/api/v1/questions/#{pergunta1.id}", params: 
        { question: 
        { nome: "pergunta2"}
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq(
          {
            "nome" => ["já cadastrada"]
          }
        )
      end

      it "não edita pergunta sem tipo de pergunta" do
        patch "/api/v1/questions/#{pergunta1.id}", params: 
        { question: 
        { tipo_de_questao: ""}
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq(
          {
            "tipo_de_questao" => ["não pode ser vazio"]
          }
        )
      end

      it "não edita pergunta sem id de formulário" do
        patch "/api/v1/questions/#{pergunta1.id}", params: 
        { question: 
        { formulary_id: ""}
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq(
          {
            "formulary" => ["must exist"]
          }
        )
      end

    end
  end


  describe "DELETE /questions/:id" do
    it "deleta uma pergunta" do
      delete "/api/v1/questions/#{pergunta1.id}"

      expect(response).to have_http_status(:no_content)
    end
  end
end
