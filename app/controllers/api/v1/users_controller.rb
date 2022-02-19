module Api
  module V1
    class UsersController < ApplicationController

      

      before_action :set_user, only: %i[ show update destroy ]

      before_action :authenticate_user, only: [:update, :destroy, :index]


      def index
        @users = User.limit(limit).offset(params[:offset])

        render json: UsersRepresenter.new(@users).as_json
      end


      def show
        render json: @user
      end


      def create
        @user = User.new(user_params)

        if @user.save
          render json: UserRepresenter.new(@user).as_json, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end


      def update
        if @user.update(user_params)
          render json: UserRepresenter.new(@user).as_json, status: :accepted
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end


    
      def destroy
        @user.destroy

        head :no_content
      end

      private

        


        def set_user
          @user = User.find(params[:id])
        end


        def user_params
          params.require(:user).permit(:nome, :password, :email, :cpf)
        end
    end
  end
end