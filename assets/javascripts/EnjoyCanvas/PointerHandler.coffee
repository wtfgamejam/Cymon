class EnjoyCanvas.PointerHandler
  app: null
  hammer_options:
    prevent_default: true,
    drag_max_touches: 2,
    transform_min_scale: 0.08,
    transform_min_rotation: 180,
    transform_always_block: true,
    drag: true
    hold: false,
    release: false,
    swipe: false,
    tap: false

  constructor: (entity) ->
    @assigned_entities = []
    @entity = entity

  initialize: ->
    return if @app is null

    @app.mouse.disableContextMenu()
    @hammer = Hammer @app.graphicsDevice.canvas, @hammer_options
    @_delegateEvents()


  events: {}


  get_touched_entity_from: (event) ->
    output = null
    from = @entity.getPosition()
    to   = @entity.camera.screenToWorld(event.center.x, event.center.y, @entity.camera.farClip)

    @app.systems.rigidbody.raycastFirst from, to, (result) -> output = result.entity
    output


  assign_entity: (entity) ->
    @assigned_entities.push entity


  remove_entity: (entity) ->
    @assigned_entities.length = 0
    # will do later :P


  _delegateEvents: ->
    _(@events).each (method_name, event) =>
      @hammer.on event, _(@[method_name]).bind(this) if @[method_name] instanceof Function
