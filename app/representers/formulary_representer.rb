class FormularyRepresenter
    def initialize(formulary)
        @formulary =  formulary
    end

    def as_json
        {
            nome: @formulary.nome,
            questoes: array_de_questoes()

        }
    end
    private

    def array_de_questoes
        questoes = []
        @formulary.questions.each do |questao|
            array = []
            array.append(questao.nome)
            array.append(questao.tipo_de_questao)
            questoes.append(array)
            
        end

        return questoes
    end

    attr_reader :formulary

end