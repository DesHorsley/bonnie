class BonnieRouter extends Backbone.Router

  initialize: ->
    @mainView = new Thorax.LayoutView(el: '#bonnie')
    # This measure collection gets populated as measures are loaded via their individual JS
    # files (see app/views/measures/show.js.erb)
    @measures = new Thorax.Collection()
    @patients = new Thorax.Collections.Patients()

  routes:
    '':                'measures'
    'measures':        'measures'
    'measures/matrix': 'matrix'
    'measures/:id':    'measure'

  measures: ->
    # FIXME: Can we cache the generation of these views?
    measuresView = new Thorax.Views.Measures(measures: @measures)
    @mainView.setView(measuresView)

  measure: (id) ->
    measureView = new Thorax.Views.Measure(model: @measures.get(id))
    @mainView.setView(measureView)

  matrix: ->
    matrixView = new Thorax.Views.Matrix(measures: @measures, patients: @patients)
    @mainView.setView(matrixView)

    # FIXME: This calculation code is rough (is timeout best approach to display while "loading"?)
    # FIXME: This calculation code should be elsewhere
    @patients.each (p) =>
      unless p.has('results')
        calculate = =>
          results = @measures.map (m) ->
            result = m.calculate(p)
            pops = []
            if result.NUMER then pops.push 'NUM'
            else if result.DENOM then pops.push 'DEN'
            else if result.MSRPOPL then pops.push 'POPL'
            else if result.IPP then pops.push 'IPP'
            if result.DENEXCEP then pops.push 'EXC'
            if result.DENEX then pops.push 'EX'
            pops.join('/')
          p.set('results', results)
        setTimeout calculate, 0 # Defer calculation to allow rendering to happen