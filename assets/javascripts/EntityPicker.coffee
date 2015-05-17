pc.script.create 'EntityPicker', (app) ->
  class EntityPicker
    constructor: (entity) ->
      @entity = entity

    initialize: ->
      app.mouse.disableContextMenu()
      app.mouse.on pc.input.EVENT_MOUSEDOWN, @onSelect, this

    update: (dt) ->

    onSelect: (e) ->
      from = @entity.getPosition()
      to   = @entity.camera.screenToWorld(e.x, e.y, @entity.camera.farClip)

      app.systems.rigidbody.raycastFirst from, to, (result) ->
        pickedEntity = result.entity
        pickedEntity.fire 'selected'