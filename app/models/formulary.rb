class Formulary < ApplicationRecord

    acts_as_paranoid

    validates :nome , presence: {message: "não pode ser vazio"}, uniquiness: {case_sensitive: false, message: "já cadastrado"}

end
