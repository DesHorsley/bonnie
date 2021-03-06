class Thorax.Views.MeasureUploadSummary extends Thorax.Views.BonnieView
  template: JST['measure_upload_summary']

  events:
    'click .patient-link': -> @trigger "patient:selected" # Event for if the link on the modal is clicked
    rendered: ->
      # Set first tab as active
      @$("[role='presentation']").first().addClass("active")
      @$("[data-toggle='tab']").first().addClass("active")
      @$("[role='tabpanel']").first().addClass("active")

  initialize: ->
    @populationInformation = [] # One element per population
    populationTitles = @measure.get('populations').map ((populationSet) -> populationSet.get('title'))
    for populationSet, populationSetIndex in @model.get('population_set_summaries')
      patientsWhoChanged = [] # One hash per patient who changed
      totalChanged = 0
      totalPatients = @measure.get('patients').length
      populationSummary = populationSet.summary
      # toFixed(1) trims decimal to 1 decimal point, but converts to string. parseFloat converts to float, because the Knob requires input as float
      percentPassedBefore = parseFloat(((populationSummary.pass_before/totalPatients) * 100).toFixed(1))
      percentPassedAfter = parseFloat(((populationSummary.pass_after/totalPatients) * 100).toFixed(1))
      for patientOID, patientInformation of populationSet.patients
        if patientInformation.pre_upload_status != patientInformation.post_upload_status
          totalChanged++
          patient = @measure.get('patients').findWhere(_id: patientOID)
          patientsWhoChanged.push({name: "#{patient.get('first')} #{patient.get('last')}", patientID: patient.id, post_upload_status: patientInformation.post_upload_status})
      @populationInformation[populationSetIndex] = {
        totalPatients: totalPatients,
        totalChanged: totalChanged,
        percentageDialBeforeMeasureUpload: {done: true, percent: percentPassedBefore, status: if percentPassedBefore == 100 then 'pass' else 'fail'}
        percentageDialAfterMeasureUpload: {done: true, percent: percentPassedAfter, status: if percentPassedAfter == 100 then 'pass' else 'fail'}
        patientsWhoChanged: patientsWhoChanged
        populationTitle: populationTitles[populationSetIndex]
        }

  context: ->
    changedPatientIDs = _.flatten(@populationInformation.map (populationInfo) ->
      return populationInfo.patientsWhoChanged.map((p) -> return p.patientID))

    _(super).extend
      populationInformation: @populationInformation,
      numberOfPopulations: @measure.get('populations').size(),
      hqmfSetId: @measure.get('hqmf_set_id'),
      totalPatientsNumber: @measure.get('patients').length,
      changedPatientsNumber: _.uniq(changedPatientIDs).length
