class VisitRepresenter
    def initialize(visit)
        @visit =  visit
    end

    def as_json
        {
            data: @visit.data,
            status: @visit.status,
            nome_usuario: @visit.user.nome,
            checkin_at: @visit.checkin_at,
            checkout_at: @visit.checkout_at
        }
    end
    private

    attr_reader :visit

end