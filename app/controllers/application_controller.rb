class ApplicationController < ActionController::API
    rescue_from ActiveRecord::RecordNotDestroyed, with: :not_destroyed

    include ActionController::HttpAuthentication::Token


    MAX_PAGINATION_LIMIT = 100

    private

    def authenticate_user
        # Authorization: Bearer <token>
        token, _options = token_and_options(request)
        chave = AuthenticationTokenService.decode(token)
        pesquisa = chave.split(' ')
        User.find_by(cpf:pesquisa[0])
        
      rescue ActiveRecord::RecordNotFound, JWT::DecodeError
        render status: :unauthorized
      end

    def limit
        [params.fetch(:limit, MAX_PAGINATION_LIMIT).to_i, MAX_PAGINATION_LIMIT].min
    end

    def not_destroyed(e)
        render json: {errors: e.record.errors}, status: :unprocessable_entity
    end

end
