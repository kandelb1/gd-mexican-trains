extends Node2D
class_name Bonepile

@onready var label: Label = $%BonesLeft
@onready var container: VBoxContainer = $VBoxContainer
@onready var domino: Control = $VBoxContainer/Control

var disabled = false


func _ready():
  modulate = Color.WHITE
  # _set_disabled(false)
  container.mouse_entered.connect(on_mouse_enter)
  container.mouse_exited.connect(on_mouse_exit)


# func _set_disabled(val: bool):
#   disabled = val
#   $Area2D/CollisionShape2D.disabled = val


func update_bones_left(num: int):
  label.text = "{0} left".format([num])
  if num <= 0:
    label.text = "Pass Turn"
    # _set_disabled(true)
    # modulate = Color("ffffff3c") # white but slightly transparent
    $VBoxContainer/Control/TextureRect.modulate = Color("ffffff3c")


func on_mouse_enter():
  modulate = Color("ffffffb4")
  # if !disabled:
  #   domino.modulate = Color("ffffffb4")


func on_mouse_exit():
  modulate = Color.WHITE
  # if !disabled:
  #   domino.modulate = Color.WHITE