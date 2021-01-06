extends TextureButton

# Constantes e Preloads
const oTex = preload("res://Sprites/OGlow.png")
const xTex = preload("res://Sprites/XGlow.png")
const hoverTex = preload("res://Sprites/Hover.png")


onready var CtrlGame = $"/root/CtrlGame"

# Variáveis de Base
var Valor = 0
export(int) var Row = -1
export(int) var Col = -1

# Lista de Sinais emitidos.
signal custom_pressed(button)

func _ready():
	reset()
	
func reset():
	_set_valores(0, null, hoverTex)
	
func setX(val):
	_set_valores(val, xTex, xTex)
	
func setO(val):
	_set_valores(val, oTex, oTex)	

func _set_valores(valor, normal, hover):
	Valor = valor
	texture_normal = normal
	texture_hover = hover

func _on_TileButton_pressed():
	if (not CtrlGame.Pause):
		emit_signal("custom_pressed", self)

