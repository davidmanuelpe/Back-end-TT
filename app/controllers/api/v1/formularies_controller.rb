module Api
  module V1
    class FormulariesController < ApplicationController
      before_action :set_formulary, only: %i[ show update destroy ]

      before_action :authenticate_user, only: [:update, :destroy, :index, :create]

      # GET /formularies
      def index
        @formularies = Formulary.limit(limit).offset(params[:offset])

        render json: FormulariesRepresenter.new(@formularies).as_json
      end

      # GET /formularies/1
      def show
        render json: @formulary
      end

      # POST /formularies
      def create
        @formulary = Formulary.new(formulary_params)

        if @formulary.save
          render json: FormularyRepresenter.new(@formulary).as_json, status: :created
        else
          render json: @formulary.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /formularies/1
      def update
        if @formulary.update(formulary_params)
          render json: FormularyRepresenter.new(@formulary).as_json, status: :accepted
        else
          render json: @formulary.errors, status: :unprocessable_entity
        end
      end

      # DELETE /formularies/1
      def destroy
        @formulary.destroy

        head :no_content
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_formulary
          @formulary = Formulary.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def formulary_params
          params.require(:formulary).permit(:nome)
        end
    end
  end
end
