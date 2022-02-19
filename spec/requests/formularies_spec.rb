require 'rails_helper'



RSpec.describe "/formularies", type: :request do
  let!(:user5) {FactoryBot.create(:user, nome: 'David5', password: '123456789', email: 'davidese3@gmail.com', cpf: '352.418.274-71')}

  let!(:form1) {FactoryBot.create(:formulary, nome:"pesquisa1")}
  let!(:form2) {FactoryBot.create(:formulary, nome:"pesquisa2")}

  let!(:pergunta1) {FactoryBot.create(:question, nome:"pergunta1", tipo_de_questao:"foto", formulary_id:form1.id)}

  let!(:pergunta2) {FactoryBot.create(:question, nome:"pergunta1", tipo_de_questao:"foto", formulary_id:form1.id)}

  before do  
    allow(AuthenticationTokenService).to receive(:decode).and_return(user5.cpf + " - " + user5.email)
  end

  describe "GET /formularies" do
    it 'listar formulários' do
      get '/api/v1/formularies'
        array_perguntas_form_1 = []
        questoes1 = []
        questoes1.append(pergunta1.nome)
        questoes1.append(pergunta1.tipo_de_questao)
        array_perguntas_form_1.append(questoes1)
        questoes2 = []
        questoes2.append(pergunta2.nome)
        questoes2.append(pergunta2.tipo_de_questao)
        array_perguntas_form_1.append(questoes2)
        expect(response).to have_http_status(:ok)
        expect(response_body.size).to eq(2)
        expect(response_body).to eq(
          [
            {
              "nome" => "pesquisa1",
              "questoes" => array_perguntas_form_1
            },
            {
              "nome" => "pesquisa2",
              "questoes" => []
            }
          ]
        )
    end

    it "lista um subgrupo de formulários baseado no limite" do
      get '/api/v1/formularies', params: { limit: 1}
      array_perguntas_form_1 = []
      questoes1 = []
      questoes1.append(pergunta1.nome)
      questoes1.append(pergunta1.tipo_de_questao)
      array_perguntas_form_1.append(questoes1)
      questoes2 = []
      questoes2.append(pergunta2.nome)
      questoes2.append(pergunta2.tipo_de_questao)
      array_perguntas_form_1.append(questoes2)
      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq(
        [
          {
            "nome" => "pesquisa1",
            "questoes" => array_perguntas_form_1
          }
        ]
      )
  
    end
    it "lista um subgrupo de formulários baseado no limite e no offset" do
      get '/api/v1/formularies', params: { limit: 1, offset: 1}
      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq(
        [
          {
            "nome" => "pesquisa2",
            "questoes" => []
          }
        ]
      )
    end
    it "tem um limite máximo de 100 respostas por pesquisa" do
      #para evitar causar congestionamento de consultas e deixar o sistema lento
      expect(Formulary).to receive(:limit).with(100).and_call_original
      get '/api/v1/formularies', params: { limit: 999 }
    end 
  end  




  describe "POST /formularies" do
    context "com parâmetros válidos" do
      it "cria um novo formulário" do
        expect{
          post '/api/v1/formularies', params: 
          { formulary: 
          { nome: "pesquisa3"}
          }
        }.to change { Formulary.count}.from(2).to(3)
        expect(response).to have_http_status(:created)
        expect(response_body).to eq(
          {
            "nome" => "pesquisa3",
            "questoes" => []
          }
        )
      end
    end
    context "com parâmetros inválidos" do
      it "não cria formulário sem nome" do
        expect{
          post '/api/v1/formularies', params: 
          { formulary: 
          { nome: ""}
          }
        }.to change { Formulary.count}.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq(
          {
            "nome" => ["não pode ser vazio"]
          }
        )
      end
    end
  end

  describe "PUT /update/:id" do
    context "com parâmetros válidos" do
      it "edita um formulário" do
        patch "/api/v1/formularies/#{form2.id}", params: 
        { formulary: 
        { nome: "pesquisa8"}
        }
        expect(response).to have_http_status(:accepted)
        expect(response_body).to eq(
          {
            "nome" => "pesquisa8",
            "questoes" => []
          }
        )
      end
    end
    context "com parâmetros inválidos" do
      it "não edita formulário sem nome" do
        patch "/api/v1/formularies/#{form2.id}", params: 
        { formulary: 
        { nome: ""}
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq(
          {
            "nome" => ["não pode ser vazio"]
          }
        )
      end
    end
  end


  describe "DELETE /formularies/:id" do
    it "deleta um formulário" do
      delete "/api/v1/formularies/#{form2.id}"

      expect(response).to have_http_status(:no_content)
    end
  end
end
