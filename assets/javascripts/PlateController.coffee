pc.script.create 'PlateController', (app) ->
  class PlateController extends EnjoyCanvas.AnimateController
    initialize: ->
      @init_animator_variables()
      @entity.on 'selected', @toggle, this


    toggle: (event) ->
      return if @animating

      @animating = true
      @animate rotation: {z: -180}, seconds: 1, =>
        @animating = false



