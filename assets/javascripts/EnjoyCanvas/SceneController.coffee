class EnjoyCanvas.SceneController
  app: null
  camera_name: null

  hammer_options:
    prevent_default: true
    drag_max_touches: 1

  constructor: (entity) ->
    @entity = entity
    @_initialize_handler() if @app

  initialize: ->
    @_init_camera_entity()

  events: {}

  _init_camera_entity: ->
    @camera_entity = @app.root.findByName @camera_name


  get_touched_entity_from: (event) ->
    output = null
    from = @camera_entity.getPosition()
    to   = @camera_entity.camera.screenToWorld(event.center.x, event.center.y, @camera_entity.camera.farClip)

    @app.systems.rigidbody.raycastFirst from, to, (result) -> output = result.entity
    output


  _delegateHammerEvents: ->
    _(@events).each (method_name, event) =>
      @hammer.on event, _(@[method_name]).bind(this) if @[method_name] instanceof Function


  _initialize_handler: ->
    @app.mouse.disableContextMenu()
    @hammer = Hammer @app.graphicsDevice.canvas, @hammer_options
    @hammer.add new Hammer.Pan direction: Hammer.DIRECTION_ALL

    @_delegateHammerEvents()