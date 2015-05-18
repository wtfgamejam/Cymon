pc.script.create 'controller', (app) ->
  class GameSceneController extends EnjoyCanvas.SceneController
    app: app
    camera_name: 'Camera'

    initialize: ->
      window.game_scene_controller = this
      @plate_controllers = {}
      @recorded_steps    = new Cymon.Steps
      super

    events:
      'tap':      'select_entity'
      'panstart': 'assign_entity'
      'pan':      'spin_entity'
      'panend':   'release_entity'


    select_entity: (event) ->
      if entity = @get_touched_entity_from(event)
        entity.fire 'tap'
        @recorded_steps.add_with_order entity.script.controller.get_current_status()


    assign_entity: (event) ->
      if @assigned_entity = @get_touched_entity_from event
        @assigned_direction = switch event.direction
          when Hammer.DIRECTION_LEFT, Hammer.DIRECTION_RIGHT then 'horizontal'
          when Hammer.DIRECTION_UP, Hammer.DIRECTION_DOWN    then 'vertical'

    spin_entity: (event) ->
      if entity = @assigned_entity
        entity.fire "flip-#{@assigned_direction}", x: event.deltaX, y: event.deltaY

    release_entity: (event)->
      if entity = @assigned_entity
        direction = switch @assigned_direction
          when 'horizontal'
            if event.deltaX > 0 then 'right' else 'left'
          when 'vertical'
            if event.deltaY > 0 then 'down' else 'up'

        delete @assigned_entity
        delete @assigned_direction

        entity.fire "fliped", direction
        @recorded_steps.add_with_order entity.script.controller.get_current_status()


    replay: ->
      queue = []
      @recorded_steps.each (step) =>
        controller = @find_plate_controller_from step
        action = step.get('action').split(',')
        queue.push switch action[0]
          when 'tapped' then -> controller.mimic 'tap'
          when 'flipped' then -> controller.mimic 'flip', direction: action[1]


      _(queue).each (mimic_action, index) ->
        setTimeout mimic_action, 200 + 1200*index

      return



    add_plate_controller: (controller) ->
      @plate_controllers[controller.plate_id] = controller


    find_plate_controller_from: (step) =>
      @plate_controllers[step.get('plate_id')]



