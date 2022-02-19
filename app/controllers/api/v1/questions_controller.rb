module Api
  module V1
    class QuestionsController < ApplicationController
      before_action :set_question, only: %i[ show update destroy ]

      before_action :authenticate_user, only: [:update, :destroy, :index, :create]

      # GET /questions
      def index
        @questions = Question.limit(limit).offset(params[:offset])

        render json: QuestionsRepresenter.new(@questions).as_json
      end

      # GET /questions/1
      def show
        render json: @question
      end

      # POST /questions
      def create
        @question = Question.new(question_params)

        if @question.tipo_de_questao == "image"
          image = params[:image]
          
          @question.image.attach(io: File.open(image), filename: "image.jpg", content_type: "image/jpeg")
        end

        if @question.save
          render json: QuestionRepresenter.new(@question).as_json, status: :created
        else
          render json: @question.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /questions/1
      def update

        if @question.tipo_de_questao == "image"
          image = params[:image]
          
          @question.image.attach(io: File.open(image), filename: "image.jpg", content_type: "image/jpeg")
        end


        if @question.update(question_params)
          render json: QuestionRepresenter.new(@question).as_json, status: :accepted
        else
          render json: @question.errors, status: :unprocessable_entity
        end
      end

      # DELETE /questions/1
      def destroy
        @question.destroy

        head :no_content
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_question
          @question = Question.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def question_params
          params.require(:question).permit(:nome, :tipo_de_questao, :formulary_id, :image)
        end
    end
  end
end
