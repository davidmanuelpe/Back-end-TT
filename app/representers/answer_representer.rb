class AnswerRepresenter
    def initialize(answer)
        @answer =  answer
    end

    def as_json
        {
            content: @answer.content,
            answered_at: @answer.answered_at,
            nome_formulario: @answer.formulary.nome,
            nome_questao: @answer.question.nome,
        }
    end
    private

    attr_reader :answer

end