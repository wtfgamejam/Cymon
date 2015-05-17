pc.script.create 'EntityPicker', (app) ->
  class EntityPicker extends EnjoyCanvas.PointerHandler
    app: app
    events:
      'tap': 'test'

    test: (event) ->
      entity = @get_touched_entity_from event
      entity.fire 'selected'