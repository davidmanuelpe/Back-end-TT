class User < ApplicationRecord

    acts_as_paranoid
    has_secure_password

    validates :nome, presence: {message: "Não pode ser vazio"}
    validates :password, length: {minimum: 7, message: "Não pode ter menos do que 7 dígitos"}
    validates :email, presence: {message: "Não pode ser vazio"}, format: { with: URI::MailTo::EMAIL_REGEXP, message: "formato incorreto" }, uniqueness: {case_sensitive: false, message: "já cadastrado"}
    validates :cpf, presence: {message: "Não pode ser vazio"}, format: { with: /\A\d{3}\.\d{3}\.\d{3}\-\d{2}\z/, message: "Inválido, deve ser no formato: 999.999.999-99"}, length: { is: 14 , message: "Deve ter exatamente 14 dígitos"}, uniqueness: {message: "já cadastrado"}
    validate :cpf_valido

    def calculo_de_verificacao(soma_total)
    
        resto = soma_total % 11
    
        saida = 11 - resto
    
        if saida >= 10
            saida = 0
        end
    
        return saida
    end

    def cpf_valido

        if (cpf.nil?) || (!cpf.length.equal?(14))
            return
        end

        entrada = cpf

        soma_total_1 = (10*entrada[0].to_i) + (9*entrada[1].to_i) + (8*entrada[2].to_i) + (7*entrada[4].to_i) + (6*entrada[5].to_i) + (5*entrada[6].to_i) + (4*entrada[8].to_i) + (3*entrada[9].to_i) + (2*entrada[10].to_i)

        verificacao_1 = calculo_de_verificacao(soma_total_1)

        unless (verificacao_1.equal?(entrada[12].to_i))
            errors.add(:cpf, "é inválido")
            return
        end

        soma_total_2 = (11*entrada[0].to_i) + (10*entrada[1].to_i) + (9*entrada[2].to_i) + (8*entrada[4].to_i) + (7*entrada[5].to_i) + (6*entrada[6].to_i) + (5*entrada[8].to_i) + (4*entrada[9].to_i) + (3*entrada[10].to_i) + (2*entrada[12].to_i)

        verificacao_2 = calculo_de_verificacao(soma_total_2)

        unless (verificacao_2.equal?(entrada[13].to_i))
            errors.add(:cpf, "é inválido")
        end
    end

end
