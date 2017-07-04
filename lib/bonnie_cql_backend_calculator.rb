# Calculate CQL measures from ruby, using V8.
#
# Example use:
# calculator = BonnieCqlBackendCalculator.new
# calculator.calculate(measure, population_index, patient)
#
class BonnieCqlBackendCalculator

  def initialize
    # Set up the V8 context and evaluate the basic libraries
    @v8 = V8::Context.new

    # Add all assets to V8 environment
    environment = Sprockets::Environment.new
    Rails.application.config.assets[:paths].each do |path|
      environment.append_path path
    end

    # Evaluate the minimal cql requirements to calculate cql
    @v8.eval environment['cql.js'].to_s
  end

  # Calculate a patient against the previously set up measure and population, returning the result
  def calculate(measure, population_index, patient)
     debugger
    # result = @v8.eval "calculatePatient(#{patient.to_json(except: :results)})"
    # JSON.parse(result)
  end

end
