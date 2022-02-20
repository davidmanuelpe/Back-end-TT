class Answer < ApplicationRecord
  acts_as_paranoid
  belongs_to :formulary
  belongs_to :question
  belongs_to :visit
  validate :status_visita
  validates :content, presence: {message: "não pode ser vazio"}


  def status_visita

    if visit_id?
      visita = Visit.find(visit_id)
      if visita.status.downcase.eql?('pendente')
        errors.add(:visita_id, "a visita ainda não aconteceu, não pode ainda responder")
      end
      if visita.status.downcase.eql?('realizado')
        errors.add(:visita_id, "a visita já aconteceu, não pode mais responder")
      end
    end

  end
end
