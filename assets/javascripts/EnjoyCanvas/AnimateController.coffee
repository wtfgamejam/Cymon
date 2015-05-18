class EnjoyCanvas.AnimateController
  constructor: (entity) ->
    @entity = entity
    @init_animator_variables()
    @_delegateEvents()

  initialize: ->


  update: (dt) ->
    @run_animation dt

  events: {}

  run_animation: (dt) ->
    @_animate.call this, dt if @_animate instanceof Function

  animate: (options, callback) ->
    animations = []
    factor     = 0
    scale_options    = {}
    position_options = {}
    rotation_options = {}

    end_callback = ->
      delete @_animate
      callback.call this if callback instanceof Function

    easing = (factor) ->
      # return (-1 / (10*Math.sin((factor+0.058) * (Math.PI/2.118))))+ 1.1;
      Math.sin factor * Math.PI / 2

    # if scale
    if typeof(options.scale) is 'number'
      scale_options.start = @current.scale
      scale_options.diff  = options.scale - (@current.scale)
      animations.push (factor) ->
        new_scale = scale_options.diff * factor + scale_options.start
        @entity.setLocalScale new_scale * @original.scale.x, new_scale * @original.scale.y, new_scale * @original.scale.z
        @current.scale = new_scale


    # if position
    if typeof(options.position) is 'object'
      @_init_current_position()
      position_options.start = x: @current.position.x, y: @current.position.y, z: @current.position.z
      position_options.to    = x: 0, y: 0, z: 0

      position_options.to.x = options.position.x if typeof(options.position.x) is 'number'
      position_options.to.y = options.position.y if typeof(options.position.y) is 'number'
      position_options.to.z = options.position.z if typeof(options.position.z) is 'number'

      animations.push (factor) ->
        new_x = position_options.to.x * factor + position_options.start.x
        new_y = position_options.to.y * factor + position_options.start.y
        new_z = position_options.to.z * factor + position_options.start.z
        @entity.setLocalPosition new_x, new_y, new_z


    # if rotation
    if typeof(options.rotation) is 'object'
      @_init_current_rotation()
      rotation_options.start = x: @current.rotation.x, y: @current.rotation.y, z: @current.rotation.z
      rotation_options.to    = x: 0, y: 0, z: 0

      rotation_options.quat = new pc.Quat
      rotation_options.to.x = options.rotation.x if typeof(options.rotation.x) is 'number'
      rotation_options.to.y = options.rotation.y if typeof(options.rotation.y) is 'number'
      rotation_options.to.z = options.rotation.z if typeof(options.rotation.z) is 'number'

      animations.push (factor) ->
        new_x = rotation_options.to.x * factor + rotation_options.start.x
        new_y = rotation_options.to.y * factor + rotation_options.start.y
        new_z = rotation_options.to.z * factor + rotation_options.start.z
        rotation_options.quat.setFromEulerAngles new_x, new_y, new_z
        @entity.setLocalRotation rotation_options.quat


    @_animate = (dt) ->
      factor += dt / options.seconds
      factor = 1 if factor > 1

      _(animations).each (animation) =>
        animation.call this, easing(factor)

      end_callback.call this if factor == 1



  init_animator_variables: ->
    @current =
      scale: 1
      rotation: { x: 0, y: 0, z: 0 }
      position: { x: 0, y: 0, z: 0 }

    @original =
      scale:    _(@entity.getLocalScale()).pick('x', 'y', 'z')
      rotation: _(@entity.getLocalRotation().getEulerAngles()).pick('x', 'y', 'z')
      position: _(@entity.getLocalPosition()).pick('x', 'y', 'z')

  _init_current_position: ->
    @current.position = _(@entity.getLocalPosition()).pick('x', 'y', 'z')

  _init_current_rotation: ->
    @current.rotation = _(@entity.getLocalRotation().getEulerAngles()).pick('x', 'y', 'z')


  _delegateEvents: ->
    _(@events).each (method_name, event) =>
      @entity.on event, _(@[method_name]).bind(this) if @[method_name] instanceof Function
