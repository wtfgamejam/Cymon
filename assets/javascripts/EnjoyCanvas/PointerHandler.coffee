class EnjoyCanvas.PointerHandler
  app: null
  hammer_options:
    prevent_default: true
    drag_max_touches: 1

  constructor: (entity) ->
    @entities = []
    @entity = entity

  initialize: ->
    return if @app is null

    @app.mouse.disableContextMenu()
    @hammer = Hammer @app.graphicsDevice.canvas, @hammer_options
    @hammer.add new Hammer.Pan direction: Hammer.DIRECTION_ALL

    @_delegateEvents()


  events: {}


  get_touched_entity_from: (event) ->
    output = null
    from = @entity.getPosition()
    to   = @entity.camera.screenToWorld(event.center.x, event.center.y, @entity.camera.farClip)

    @app.systems.rigidbody.raycastFirst from, to, (result) -> output = result.entity
    output


  _delegateEvents: ->
    _(@events).each (method_name, event) =>
      @hammer.on event, _(@[method_name]).bind(this) if @[method_name] instanceof Function
