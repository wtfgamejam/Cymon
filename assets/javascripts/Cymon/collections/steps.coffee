class Cymon.Steps extends Backbone.Collection
  model: Cymon.Step


  add_with_order: (data) ->
    data.order = @get_last_order() + 1
    @add data


  get_last_order: ->
    try output = @last().id
    output or 0
