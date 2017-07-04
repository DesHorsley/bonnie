namespace :bonnie do
  namespace :cql_calculation_tests do

    desc 'Calculate every cql based patient in the database'
    task :calculate_all => :environment do
      STDOUT.sync = true
      calculator = BonnieCqlBackendCalculator.new
      query = {}
      query[:user_id] = User.where(email: ENV["EMAIL"]).first.try(:id) if ENV["EMAIL"]
      query[:cms_id] = ENV["CMS_ID"] if ENV["CMS_ID"]
      measures = CqlMeasure.where(query)
      measures.each do |measure|
        measure.populations.each_with_index do |population, population_index|
          patients = Record.where(user_id: measure.user_id, measure_ids: measure.hqmf_set_id)
          patients.each do |patient|
            unless setup_exception
              begin
                result = calculator.calculate(measure, population_index, patient)
                debugger
              rescue => e
                calculation_exception = "Measure calculation exception: #{e.message}"
              end
            end
          end
        end
      end
    end

  end
end
