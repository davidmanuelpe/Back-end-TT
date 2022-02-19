module Api
  module V1
    class VisitsController < ApplicationController
      before_action :set_visit, only: %i[ show update destroy ]

      before_action :authenticate_user, only: [:update, :destroy, :index, :create]

      # GET /visits
      def index
        @visits = Visit.limit(limit).offset(params[:offset])

        render json: VisitsRepresenter.new(@visits).as_json
      end

      # GET /visits/1
      def show
        render json: @visit
      end

      # POST /visits
      def create
        @visit = Visit.new(visit_params)

        if @visit.save
          render json: VisitRepresenter.new(@visit).as_json, status: :created
        else
          render json: @visit.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /visits/1
      def update
        if @visit.update(visit_params)
          render json: VisitRepresenter.new(@visit).as_json, status: :accepted
        else
          render json: @visit.errors, status: :unprocessable_entity
        end
      end

      # DELETE /visits/1
      def destroy
        @visit.destroy

        head :no_content
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_visit
          @visit = Visit.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def visit_params
          params.require(:visit).permit(:data, :status, :checkin_at, :checkout_at, :user_id)
        end
    end
  end
end
