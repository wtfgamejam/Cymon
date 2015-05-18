pc.script.create 'PlateController', (app) ->
  class PlateController extends EnjoyCanvas.AnimateController
    events:
      'tap': 'toggle'
      'rotate-horizontal': 'rotate_horizontal'
      'rotate-vertical':   'rotate_vertical'
      'rotated': 'finish_rotating'



    toggle: ->
      return if @animating

      @animating = true
      @animate position: {y: -0.2}, seconds: 0.2, =>
        @animate position: {y: 0.2}, seconds: 0.2, =>
          @animating = false


    rotate_horizontal: (delta) ->
      return if @animating

      z = delta.x * -1.5
      z = -180 if z < -180
      z = 180 if z > 180
      @add_rotation 0, 0, z
      @_last_rotation_z = z

    rotate_vertical: (delta) ->
      return if @animating

      x = delta.y * 1.5
      x = -180 if x < -180
      x = 180 if x > 180
      @add_rotation x, 0, 0
      @_last_rotation_x = x


    finish_rotating: (finished_direction) ->
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






    add_rotation: (x, y, z) ->
      quat = new pc.Quat
      quat.setFromEulerAngles x, y, z
      @entity.setLocalRotation quat