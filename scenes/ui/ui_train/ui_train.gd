extends Node2D
class_name UITrain

@export var domino_scene: PackedScene

@onready var scroll_container: ScrollContainer = $ScrollContainer
@onready var vbox_container: VBoxContainer = $ScrollContainer/VBoxContainer
@onready var label: Label = $Label

const rect = Rect2(Vector2(-Utils.DOMINO_WIDTH / 2, -Utils.DOMINO_HEIGHT / 2), Vector2(Utils.DOMINO_WIDTH, Utils.DOMINO_HEIGHT))
var train: TrainResource


func _ready():
  train.domino_added.connect(on_add_domino)
  train.public_status_changed.connect(on_status_changed)
  scroll_container.get_v_scroll_bar().changed.connect(update_scrollbar)
  train.changed.connect(func(): queue_redraw())
  $Open.modulate = train.player_color
  $Closed.modulate = train.player_color
  $Closed.visible = true
  if train.is_supplemental:
    $SuppLabel.visible = true
    $Closed.visible = false


func _update_label():
  label.text = str(len(train.dominos))


func _draw():
  if len(train.dominos) == 0:
    var color = Color.GRAY
    if train.is_supplemental:
      color = Color.AQUAMARINE
    draw_rect(rect, color, false, 3)


func on_add_domino(domino: DominoResource):
  var domino_instance = domino_scene.instantiate() as UIDomino
  domino_instance.domino = domino
  vbox_container.add_child(domino_instance)
  if domino.flipped:
    domino_instance.flip_upside_down()
  if domino.is_double():
    domino_instance.flip_sideways()
  _update_label()
  queue_redraw()


func update_scrollbar():
  var scrollbar = scroll_container.get_v_scroll_bar()
  scroll_container.scroll_vertical = scrollbar.max_value


func on_status_changed(is_public: bool):
  if is_public:
    $Open.visible = true
    $Closed.visible = false
  else:
    $Open.visible = false
    $Closed.visible = true


func clear():
  for child in vbox_container.get_children():
    child.queue_free()
  label.text = "0"
  queue_redraw()