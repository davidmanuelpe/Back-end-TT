class Formulary < ApplicationRecord
 
    has_many :questions, dependent: :destroy
    

    validates :nome , presence: {message: "não pode ser vazio"}, uniqueness: {case_sensitive: false, message: "já cadastrado"}

    acts_as_paranoid
end
