extends Node

var Pause = false

var VitoriasX = 0 setget setVitoriaX
var VitoriasO = 0 setget setVitoriaO
var Empates = 0 setget setEmpates

signal change_placar

func _ready():
	pass # Replace with function body.

func setVitoriaX(value):
	VitoriasX = value
	emit_signal("change_placar")

func setVitoriaO(value):
	VitoriasO = value
	emit_signal("change_placar")

func setEmpates(value):
	Empates = value
	emit_signal("change_placar")
