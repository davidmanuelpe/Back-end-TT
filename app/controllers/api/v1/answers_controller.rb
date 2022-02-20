module Api
  module V1    
    class AnswersController < ApplicationController
      before_action :set_answer, only: %i[ show update destroy ]

      before_action :authenticate_user, only: [:update, :destroy, :index, :create]

      # GET /answers
      def index
        @answers = Answer.limit(limit).offset(params[:offset])

        render json: AnswersRepresenter.new(@answers).as_json
      end

      # GET /answers/1
      def show
        render json: @answer
      end

      # POST /answers
      def create
        if (answer_params[:question_id].nil?)
          #Este if gera o erro de falta de question_id e formulary_id ao tentar o save e jogar para o model
          #Já que o questão tem obrigatoriamente um formulário relacionado à ela, estou fornecendo à resposta este id
          
          @answer = Answer.new(answer_params.merge(answered_at: Date.today))

        else
          question = Question.find(answer_params[:question_id])
          @answer = Answer.new(answer_params.merge(answered_at: Date.today, formulary_id: question.formulary.id))

        end

          if @answer.save
            render json: AnswerRepresenter.new(@answer).as_json, status: :created
          else
            render json: @answer.errors, status: :unprocessable_entity
          end
      end

      # PATCH/PUT /answers/1
      def update
        if @answer.update(answer_params)
          render json: AnswerRepresenter.new(@answer).as_json, status: :accepted
        else
          render json: @answer.errors, status: :unprocessable_entity
        end
      end

      # DELETE /answers/1
      def destroy
        @answer.destroy

        head :no_content
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_answer
          @answer = Answer.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def answer_params
          params.require(:answer).permit(:content, :question_id, :visit_id)
        end
    end
  end
end