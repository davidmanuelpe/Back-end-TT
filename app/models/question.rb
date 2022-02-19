class Question < ApplicationRecord
  acts_as_paranoid
  belongs_to :formulary
  has_one_attached :image

  validates :nome, presence: true
  validates :tipo_de_questao, presence: true

  def validar_nome_unico
  
    if nome? and formulario_id?

      formulario = Formulary.find(formulary_id)

      formulario.questions.each do |question|
        if question.nome.equals?(nome)
          errors.add("já cadastrada")
        end
      end
    end

  end

end

