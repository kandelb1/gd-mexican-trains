extends Node2D
class_name MouseManager

signal try_place_domino(domino: DominoResource, train: TrainResource)
signal bonepile_clicked

var window_height = ProjectSettings.get_setting("display/window/size/viewport_height")
var window_width = ProjectSettings.get_setting("display/window/size/viewport_width")

var selected = null


func _process(delta):
  if selected != null:
    # move the selected domino to wherever the mouse is, clamping the value so players can't drag dominos off-screen
    selected.global_position = get_global_mouse_position().clamp(Vector2(0, 0), Vector2(window_width, window_height))


func _input(event):
  if event.is_action_pressed("left_click"): # try to pick up a domino
    if selected != null:
      return
    var query_params = create_query_params()
    var bodies = get_world_2d().direct_space_state.intersect_point(query_params)
    for body in bodies:
      var parent = body["collider"].get_parent()
      if parent == null:
        return
      if parent is Domino:
        var domino = parent as Domino
        if domino.is_in_group("dominos") && !domino.is_part_of_train:
          domino.get_node("BaseImage").modulate = Color.LIGHT_GREEN # TODO: try outlining the domino in green instead
          selected = domino
          break
      if parent is Bonepile:
        bonepile_clicked.emit()
        break
  elif event.is_action_released("left_click"): # try to put down a domino
    if selected == null:
      return
    var query_params = create_query_params()
    var bodies = get_world_2d().direct_space_state.intersect_point(query_params)
    for body in bodies:
      var parent = body["collider"].get_parent()
      if parent == null:
        return
      if parent is UITrain:
        var train = parent as UITrain
        if train.is_in_group("trains"):
          var domino = selected as Domino
          try_place_domino.emit(domino.domino, train.train)
          break
    selected.get_node("BaseImage").modulate = Color.WHITE
    selected = null
  elif event.is_action_pressed("right_click"):
    if selected != null:
      selected.rotate(PI / 2)


func create_query_params():
  var mouse_pos = get_global_mouse_position()
  var query_params = PhysicsPointQueryParameters2D.new()
  query_params.position = mouse_pos
  query_params.collision_mask = 1
  query_params.collide_with_areas = true
  return query_params