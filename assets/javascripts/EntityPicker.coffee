pc.script.create 'EntityPicker', (app) ->
  class EntityPicker extends EnjoyCanvas.PointerHandler
    app: app
    events:
      'tap':      'select_entity'
      'panstart': 'assign_entity'
      'pan':      'spin_entity'
      'panend':   'release_entity'

    select_entity: (event) ->
      @get_touched_entity_from(event).fire 'tap'

    assign_entity: (event) ->
      @assigned_entity    = @get_touched_entity_from event
      @assigned_direction = switch event.direction
        when Hammer.DIRECTION_LEFT, Hammer.DIRECTION_RIGHT then 'horizontal'
        when Hammer.DIRECTION_UP, Hammer.DIRECTION_DOWN    then 'vertical'

    spin_entity: (event) ->
      if @assigned_entity
        @assigned_entity.fire "rotate-#{@assigned_direction}", x: event.deltaX, y: event.deltaY

    release_entity: (event)->
      if @assigned_entity
        direction = switch @assigned_direction
          when 'horizontal'
            if event.deltaX > 0 then 'right' else 'left'
          when 'vertical'
            if event.deltaY > 0 then 'down' else 'up'

        @assigned_entity.fire "rotated", direction
        delete @assigned_entity
        delete @assigned_direction