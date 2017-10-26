require 'test_helper'

class MeasuresControllerDownloadPackageTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  tests MeasuresController
  
  setup do
    dump_database
    users_set = File.join("users", "base_set")
    cql_measure_no_package = File.join("cql_measures", "CMS72v5")
    cql_measure_with_package = File.join("cql_measures", "CMS160v6")
    cql_measure_package = File.join("cql_measure_packages", "CMS160v6")
    collection_fixtures(users_set, cql_measure_no_package, cql_measure_with_package, cql_measure_package)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user, CqlMeasure.all)
    sign_in @user
  end
  
  test "download package returns 404 not found for nonexistent measure" do
    get :download_package, {id: '59b3109e5cc975e11c009ad4'}
    assert_response :missing
    assert_equal 'No measure found for this id.', response.body
  end

  test "download package returns 404 not found for measure without a package" do
    # attempt to get a packge for CMS72v5 which doesn't have a package
    get :download_package, {id: '59b923125cc97528cb00017e'}
    assert_response :missing
    assert_equal 'No package found for this measure.', response.body
  end

  test "download package returns the measure package for a measure with a package" do
    get :download_package, {id: '59f1fda25cc9755de6144fd6'}
    assert_response :success
    # check the Content-Disposition header (which provides filename) and contents match
    assert_equal "attachment; filename=\"CMS160v6_bonnie@example.com_2017-10-26.zip\"", response.headers['Content-Disposition']
    assert_equal File.binread(File.join('test', 'fixtures', 'cql_measure_exports', 'CMS160_v5_4_Artifacts.zip')), response.body
  end
end
