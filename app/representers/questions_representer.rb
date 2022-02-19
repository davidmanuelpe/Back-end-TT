class QuestionsRepresenter
    def initialize(questions)
        @questions =  questions
    end

    def as_json
        @questions.map do |questao|
            {
                nome: questao.nome,
                tipo_de_questao: questao.tipo_de_questao,
                respostas: array_de_respostas(questao)

            }
        end
    end

    
    private

        def array_de_respostas(questao)
            respostas = []
            questao.answers.each do |resposta|
                array = []
                array.append(resposta.content)
                array.append(resposta.answered_at)
                respostas.append(array)
                
            end
    
            return respostas
        end

    attr_reader :questions

end