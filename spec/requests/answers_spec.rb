require 'rails_helper'

RSpec.describe "/answers", type: :request do

  #Autenticando token no sistema
  let!(:user5) {FactoryBot.create(:user, nome: 'David5', password: '123456789', email: 'davidese3@gmail.com', cpf: '352.418.274-71')}
  before do  
    allow(AuthenticationTokenService).to receive(:decode).and_return(user5.cpf + " - " + user5.email)
  end

  let!(:form1) {FactoryBot.create(:formulary, nome:"pesquisa1")}

  let!(:visit1) {FactoryBot.create(:visit, data: "2023-10-12", status: "realizando", checkin_at: "nil", checkout_at: "nil", user_id: user5.id)}

  let!(:pergunta1) {FactoryBot.create(:question, nome:"pergunta1", tipo_de_questao:"foto", formulary_id:form1.id)}

  let!(:resposta) {FactoryBot.create(:answer, content:"asdsafasfas", formulary_id:pergunta1.formulary.id, question_id:pergunta1.id, visit_id:visit1.id)}

  let!(:resposta2) {FactoryBot.create(:answer, content:"22222222222222", formulary_id:pergunta1.formulary.id, question_id:pergunta1.id, visit_id:visit1.id)}




    describe "GET /answers" do
      it 'listar respostas' do
        get '/api/v1/answers'
          expect(response).to have_http_status(:ok)
          expect(response_body.size).to eq(2)
          expect(response_body).to eq(
            [
              {
                "answered_at"=>resposta.answered_at.as_json,
                "content"=>"asdsafasfas",
                "nome_formulario"=>"pesquisa1",
                "nome_questao"=>"pergunta1"
              },
              {
                "answered_at"=>resposta.answered_at.as_json,
                "content"=>"22222222222222",
                "nome_formulario"=>"pesquisa1",
                "nome_questao"=>"pergunta1"
              }
            ]
          )
      end
      it "lista um subgrupo de respostas baseado no limite" do
        get '/api/v1/answers', params: { limit: 1}
    
        expect(response).to have_http_status(:success)
        expect(response_body.size).to eq(1)
        expect(response_body).to eq(
          [
            {
              "answered_at"=>resposta.answered_at.as_json,
              "content"=>"asdsafasfas",
              "nome_formulario"=>"pesquisa1",
              "nome_questao"=>"pergunta1"
            }
          ]
        )
    
      end

      it "lista um subgrupo de respostas baseado no limite e no offset" do
        get '/api/v1/answers', params: { limit: 1, offset: 1}
        expect(response).to have_http_status(:success)
        expect(response_body.size).to eq(1)
        expect(response_body).to eq(
          [
            {
              "answered_at"=>resposta.answered_at.as_json,
              "content"=>"22222222222222",
              "nome_formulario"=>"pesquisa1",
              "nome_questao"=>"pergunta1"
            }
          ]
        )
    
      end
      it "tem um limite máximo de 100 respostas por pesquisa" do
        #para evitar causar congestionamento de consultas e deixar o sistema lento
        expect(Answer).to receive(:limit).with(100).and_call_original
        get '/api/v1/answers', params: { limit: 999 }
      end  
    end


  describe "POST /answers" do
    context "com parâmetros válidos" do
      it "cria uma nova answer" do
        expect{
          post '/api/v1/answers', params: 
          { answer: 
          {  content:"asdsafasfas", formulary_id:pergunta1.formulary.id, question_id:pergunta1.id, visit_id:visit1.id }
          }
        }.to change { Answer.count}.from(2).to(3)
        answer3 = Answer.find(3)
        expect(response).to have_http_status(:created)
        expect(response_body).to eq(
          {
            "answered_at" => answer3.answered_at.as_json,
            "content" => "asdsafasfas",
            "nome_formulario" => "pesquisa1",
            "nome_questao" => "pergunta1"
          }
        )
      end
    end
    context "com parâmetros inválidos" do
      it "não cria resposta sem content" do
        expect{
          post '/api/v1/answers', params: 
          { answer: 
          { content:"", formulary_id:pergunta1.formulary.id, question_id:pergunta1.id, visit_id:visit1.id  }
          }
        }.to change { Visit.count}.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq(
          {
            "content"=>["não pode ser vazio"]
          }
  
        )
      end

      it "não cria resposta sem pergunta" do
        expect{
          post '/api/v1/answers', params: 
          { answer: 
          { content:"dasdsads", formulary_id:pergunta1.formulary.id, visit_id:visit1.id  }
          }
        }.to change { Visit.count}.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq(
          {
            "formulary" => ["must exist"],
            "question" => ["must exist"]
          }
  
        )
      end

      it "não cria resposta sem visita" do
        expect{
          post '/api/v1/answers', params: 
          { answer: 
          { content:"dasdsads", formulary_id:pergunta1.formulary.id, question_id:pergunta1.id }
          }
        }.to change { Visit.count}.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq(
          {
            "visit" => ["must exist"]
          }
  
        )
      end

    end
  end


describe "PUT /answers/:id" do
  context "com parâmetros válidos" do
    it "edita uma resposta" do
        patch "/api/v1/answers/#{resposta.id}", params: 
        { answer: 
        { content:"33333333333", formulary_id:pergunta1.formulary.id, question_id:pergunta1.id, visit_id:visit1.id}
        }
        expect(response).to have_http_status(:accepted)
        expect(response_body).to eq(
          {
            "answered_at" => resposta.answered_at.as_json,
            "content" => "33333333333",
            "nome_formulario" => "pesquisa1",
            "nome_questao" => "pergunta1"
          }
      )
    end
  context "com parâmetros inválidos" do
    it "não edita resposta sem conteúdo" do
      expect{
        patch "/api/v1/answers/#{resposta.id}", params: 
        { answer: 
        { content:"", formulary_id:pergunta1.formulary.id, question_id:pergunta1.id, visit_id:visit1.id }
        }
      }.to change { Visit.count}.by(0)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq(
        {
          "content" => ["não pode ser vazio"]
        }

      )
    end
    it "não edita resposta sem pergunta" do
      expect{
        patch "/api/v1/answers/#{resposta.id}", params: 
        { answer: 
        { content:"asdasdsad", formulary_id:pergunta1.formulary.id, question_id:'', visit_id:visit1.id}
        }
      }.to change { Visit.count}.by(0)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq(
        {
          "question" => ["must exist"]
        }

      )
    end
    it "não edita resposta sem visita" do
      expect{
        patch "/api/v1/answers/#{resposta.id}", params: 
        { answer: 
        { content:"asdasdsad", formulary_id:pergunta1.formulary.id, visit_id:""}
        }
      }.to change { Visit.count}.by(0)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq(
        {
          "visit" => ["must exist"]
        }

      )
    end
  end
end
end


  describe "DELETE /answers/:id" do
    it "deleta uma resposta" do
      delete "/api/v1/answers/#{resposta.id}"

      expect(response).to have_http_status(:no_content)
    end
  end
end
