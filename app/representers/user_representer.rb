class UserRepresenter
    def initialize(user)
        @user =  user
    end

    def as_json
        {
            id: @user.id,
            nome: @user.nome,
            email: @user.email,
            cpf: @user.cpf
        }
    end
    private

    attr_reader :user

end