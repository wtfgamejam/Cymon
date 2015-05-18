pc.script.attribute 'plate_id', 'string', 'plate'
pc.script.create 'controller', (app) ->
  class PlateController extends EnjoyCanvas.AnimateController
    initialize: ->
      @scene_entity = app.root.findByName('GameScene')
      @scene_entity.script.controller.add_plate_controller this

    events:
      'tap': 'tapping'
      'flip-horizontal': 'flip_horizontal'
      'flip-vertical':   'flip_vertical'
      'fliped': 'finish_flipping'



    tapping: ->
      return if @animating

      @animating = true
      @animate position: {y: -0.3}, seconds: 0.15, =>
        @animate position: {y: 0.3}, seconds: 0.15, =>
          @animating = false

      @last_action = 'tapped,normal'


    flip_horizontal: (delta) ->
      return if @animating

      z = delta.x * -1.5
      z = -180 if z < -180
      z = 180 if z > 180
      @add_rotation 0, 0, z
      @_last_rotation_z = z

    flip_vertical: (delta) ->
      return if @animating

      x = delta.y * 1.5
      x = -180 if x < -180
      x = 180 if x > 180
      @add_rotation x, 0, 0
      @_last_rotation_x = x


    finish_flipping: (finished_direction) ->
      return if @animating

      @_init_current_rotation()
      @animating = true
      switch finished_direction
        when 'up'
          @animate rotation: {x: -180 - @_last_rotation_x }, seconds: 0.3, => @animating = false
        when 'down'
          @animate rotation: {x: 180 - @_last_rotation_x }, seconds: 0.3, => @animating = false
        when 'left'
          @animate rotation: {z: 180 - @_last_rotation_z }, seconds: 0.3, => @animating = false
        when 'right'
          @animate rotation: {z: -180 - @_last_rotation_z }, seconds: 0.3, => @animating = false

      @last_action = "flipped,#{finished_direction}"

    mimic: (type, options = {}) ->
      return if @animating
      @animating = true
      animating_time = 0.6

      switch type
        when 'flip'
          switch options.direction
            when 'up'
              @animate rotation: {x: -180 }, seconds: animating_time, => @animating = false
            when 'down'
              @animate rotation: {x: 180 }, seconds: animating_time, => @animating = false
            when 'left'
              @animate rotation: {z: 180 }, seconds: animating_time, => @animating = false
            when 'right'
              @animate rotation: {z: -180 }, seconds: animating_time, => @animating = false

        when 'tap'
          @animate position: {y: -0.3}, seconds: animating_time/2, =>
            @animate position: {y: 0.3}, seconds: animating_time/2, =>
              @animating = false


    add_rotation: (x, y, z) ->
      quat = new pc.Quat
      quat.setFromEulerAngles x, y, z
      @entity.setLocalRotation quat

    get_current_status: ->
      plate_id: @plate_id
      action: @last_action