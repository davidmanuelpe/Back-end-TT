class VisitsRepresenter
    def initialize(visits)
        @visits =  visits
    end

    def as_json
        @visits.map do |visit|
            {
                data: visit.data,
                status: visit.status,
                nome_usuario: visit.user.nome,
                checkin_at: visit.checkin_at,
                checkout_at: visit.checkout_at
            }
        end
    end
    private

    attr_reader :visits

end