class Visit < ApplicationRecord
  belongs_to :user

  acts_as_paranoid

  validates :data, presence: {message: "não pode ser vazio"}
  validates :status, presence: {message: "não pode ser vazio"}
  validate :validar_data_visita
  validate :validar_checkin
  validate :validar_checkout
  validate :validar_user_id


  def validar_data_visita
    if data?
      if data <= Date.today
        errors.add(:data, "tem que ser após a data de hoje")
      end
    end
  end

  def validar_checkin
    if checkin_at?
      if checkin_at >= Date.today
        errors.add(:checkin_at, "tem que ser menor que a data atual")
      end
      if checkout_at?
        if checkin_at >= checkout_at
          errors.add(:checkin_at, "não pode ser maior que a data de checkout")
        end
      end
    end
  end

  def validar_checkout
    if checkout_at?
      if checkout_at <= checkin_at
        errors.add(:checkout_at, "não pode ser menor que a data de checkin")
      end
    end
  end

  def validar_user_id
    if user_id? 
      User.find(user_id)
    end
      rescue ActiveRecord::RecordNotFound
        errors.add(:user_id, "é inválido")


  end

end
