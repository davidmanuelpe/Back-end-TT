class FormulariesRepresenter
    def initialize(formularies)
        @formularies =  formularies
    end

    def as_json
        @formularies.map do |formulary|
            {
                nome: formulary.nome,
                questoes: array_de_questoes(formulary)

            }
        end
    end
    private

    def array_de_questoes(formulary)
        questoes = []
        formulary.questions.each do |questao|
            array = []
            array.append(questao.nome)
            array.append(questao.tipo_de_questao)
            questoes.append(array)
            
        end

        return questoes
    end

    attr_reader :formularies

end