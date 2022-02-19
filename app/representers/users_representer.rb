class UsersRepresenter
    def initialize(users)
        @users =  users
    end

    def as_json
        @users.map do |user|
            {
                id: user.id,
                nome: user.nome,
                email: user.email,
                cpf: user.cpf
            }
        end
    end
    private

    attr_reader :users

end