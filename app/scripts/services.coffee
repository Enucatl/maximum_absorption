'use strict'

### Services ###

angular
    .module('app.services', ["ngResource"])

    .factory 'version', -> "0.1"

    .service 'comptonService', ->
        this.gamma = (b) ->
            (Math.pow(Math.PI, 3) / 3) * (b / (1 - 2 * Math.PI * b))

        this.df = (a, beta) ->
            Math.exp(this.gamma(beta) * (1 - 1 / a))

        this.sigma_phi = (a, beta, v, n) ->
            1 / (v * Math.sqrt(n * a) * this.df(a, beta))

        this.sigma_phi_no_compton = (a, v, n, r=0.5) ->
            #assumes a fixed log ratio of the dark field and absorption. The
            #default value comes from the low energy experiment of Zhentian
            1 / (v * Math.pow(a, r) * Math.sqrt(n * a))
        return this

    .factory 'Table', [
        "$http"
        
        ($http) ->
            $http.get "nist.data.json"
    ]

    .service 'thicknessCalculatorService', ->
        this.thickness_table = (raw_table, energy, min_tr, min_tr_05, min_tr_20) ->
            table = raw_table.map (element) ->
                array = element.table.split(/\s+/).map(parseFloat)
                rows = []
                while array.length > 0
                    rows.push array.splice 0, 3
                rows.map (d) ->
                    {
                        name: element.name
                        energy: d[0] * 1e3
                        mu: d[1] * element.density
                    }
            rows_with_energy = table.map (element) ->
                (element.filter (d) -> d.energy == energy)[0]
            rows_with_energy.map (d) ->
                {
                    name: d.name
                    t: -Math.log(min_tr) / d.mu
                    t_05: -Math.log(min_tr_05) / d.mu
                    t_20: -Math.log(min_tr_20) / d.mu
                }
        return this
