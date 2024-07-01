class MovieService
    def initialize
        @_conn = Faraday.new(
            url: 'https://api.themoviedb.org',
            params: {param: '1'},
            headers: {'Content-Type' => 'application/json'}
        )
    end

    private

    def conn
        @_conn
    end
end