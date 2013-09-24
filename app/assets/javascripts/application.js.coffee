# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery/jquery.min
#= require handlebars/handlebars
#= require underscore/underscore-min
#= require backbone/backbone-min
#= require thorax/thorax.min
#
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_self
#= require_tree .

Backbone.history.start()

TestView = Thorax.Views['test-view']
view = new TestView()
#view.appendTo '.container'

MeasuresView = Thorax.Views['measures-view']
mView = new MeasuresView()
#mView.appendTo '.container'