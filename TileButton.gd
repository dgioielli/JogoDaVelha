extends TextureButton

# Constantes e Preloads
const oTex = preload("res://OGlow.png")
const xTex = preload("res://XGlow.png")
const hoverTex = preload("res://Hover.png")

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
	
func setX(val = 1):
	_set_valores(val, xTex, xTex)
	
func setO(val = 10):
	_set_valores(val, oTex, oTex)	

func _set_valores(valor, normal, hover):
	Valor = valor
	texture_normal = normal
	texture_hover = hover

func _on_TileButton_pressed():
	emit_signal("custom_pressed", self)
