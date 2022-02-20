class AnswersRepresenter
    def initialize(answers)
        @answers =  answers
    end

    def as_json
        @answers.map do |answer|
            {
                content: answer.content,
                answered_at: answer.answered_at,
                nome_formulario: answer.formulary.nome,
                nome_questao: answer.question.nome,
            }
        end
    end
    private

    attr_reader :answers

end