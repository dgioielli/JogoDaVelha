extends Node2D

onready var Main = get_tree().get_root().get_node("Main")

var ValorPlayer = -1
var ValorInimigo = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

func aiFillRow(row):
	for col in range(3):
		if (Main.Tabuleiro[row][col].Valor == 0):
			Main.placeMark(row, col, Main.ActivePlayer)

func aiFillCol(col):
	for row in range(3):
		if (Main.Tabuleiro[row][col].Valor == 0):
			Main.placeMark(row, col, Main.ActivePlayer)

func aiFillDiag1():
	for idx in range(3):
		if (Main.Tabuleiro[idx][idx].Valor == 0):
			Main.placeMark(idx, idx, Main.ActivePlayer)

func aiFillDiag2():
	for idx in range(3):
		if (Main.Tabuleiro[idx][2 - idx].Valor == 0):
			Main.placeMark(idx, 2 - idx, Main.ActivePlayer)

func aiPicWinningFill():
	return _aiFill(2 * Main.ActivePlayer)

func aiBlock():
	return _aiFill(2 * Main.InactivePlayer)

func _aiFill(val):
	for idx in range(3):
		if (Main.sumRow(idx) == val):
			aiFillRow(idx)
			return true
		if (Main.sumCol(idx) == val):
			aiFillCol(idx)
			return true
	if (Main.sumDiag1() == val):
		aiFillDiag1()
		return true
	if (Main.sumDiag2() == val):
		aiFillDiag2()
		return true
	return false

func aiPicPoint():
	if (aiPicWinningFill()):
		return
	if (aiBlock()):
		return
	var row = randi() % 3
	var col = randi() % 3
	var valido = false
	
	while (not valido):
		if (Main.Tabuleiro[row][col].Valor == 0):
			valido = true
		else:
			row = randi() % 3
			col = randi() % 3
	Main.placeMark(row, col, Main.ActivePlayer)

