'use strict'

### Services ###

angular
    .module('app.services', [])

    .factory 'version', -> "0.1"

    .service 'comptonService', ->
        this.gamma = (b) ->
            (Math.pow(Math.PI, 3) / 3) * (b / (1 - 2 * Math.PI * b))

        this.df = (a, beta) ->
            Math.exp(this.gamma(beta) * (1 - 1 / a))

        this.sigma_phi = (a, v, n) ->
            1 / (v * Math.sqrt(n * a) * df(a))

        this.sigma_phi_no_compton = (a, v, n, r=0.5) ->
            #assumes a fixed log ratio of the dark field and absorption. The
            #default value comes from the low energy experiment of Zhentian
            1 / (v * Math.pow(a, r) * Math.sqrt(n * a))
        return this

    .service 'nistTableService', ->
        this.raw_table = $http.get "nist.data.json"
            .success (data) ->
                table = data.map (element) ->
                    array = element.table.split(/\s+/).map(parseFloat)
                    rows = []
                    while array.length > 0
                        rows.push array.splice 0, 3
                    return rows
        return this
