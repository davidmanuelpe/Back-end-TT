class Question < ApplicationRecord
  acts_as_paranoid
  belongs_to :formulary
  has_one_attached :image
  has_many :answers, dependent: :destroy

  validates :nome, presence: {message: "não pode ser vazio"}
  validates :tipo_de_questao, presence: {message: "não pode ser vazio"}
  validate :validar_nome_unico

  def validar_nome_unico
  
    if nome? and formulary_id?

      formulario = Formulary.find(formulary_id)

      formulario.questions.each do |question|
        if question.nome.eql?(nome) and !question.id.equal?(id)
          errors.add(:nome, "já cadastrada")
        end
      end
    end

  end

end

