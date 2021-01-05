extends Control

# Variáveis constantes
const ValX = 1
const ValO = 10

# Instâncias dos elementos da cena
onready var Tabuleiro = [
	[$Tiles/TileButton1, $Tiles/TileButton2, $Tiles/TileButton3],
	[$Tiles/TileButton4, $Tiles/TileButton5, $Tiles/TileButton6],
	[$Tiles/TileButton7, $Tiles/TileButton8, $Tiles/TileButton9]
]

onready var WinDialog = $WinDialog

# Variáveis de Base
var ActivePlayer = ValX
var CurrentRound = 0
var Winner = false

func _ready():
	_loadTabuleiro()
	_loadDialogBox()

func _loadTabuleiro():
	for row in Tabuleiro:
		for btn in row:
			btn.connect("custom_pressed", self, "onTileButtonPressed")

func _loadDialogBox():
	var cancelBtn = WinDialog.get_cancel()
	cancelBtn.set_text("Quit")
	cancelBtn.connect("pressed", self, "onQuit")
	WinDialog.get_ok().set_text("Play Again!")

func clearTabuleiro():
	CurrentRound = 0
	Winner = false
	ActivePlayer = ValX
	for row in Tabuleiro:
		for btn in row:
			btn.reset()

func placeMark(row, col, player):
	if player == ValX:
		Tabuleiro[row][col].setX()
		ActivePlayer = ValO
	else:
		Tabuleiro[row][col].setO()
		ActivePlayer = ValX
	
	CurrentRound += 1
	checkWin()
	
	if (CurrentRound == 9):
		showWinDialog("Draw!", "The game was a draw!")
	elif (ActivePlayer == ValO and not Winner):
		$Tween.interpolate_callback(self, 0.5 + randf(), "aiPicPoint")
		$Tween.start()

func sumRow(rowNum):
	var sum = 0
	for btn in Tabuleiro[rowNum]:
		sum += btn.Valor
	return sum

func sumCol(colNum):
	var sum = 0
	for row in Tabuleiro:
		sum += row[colNum].Valor
	return sum

func sumDiag1():
	var sum = 0
	for idx in range(3):
		sum += Tabuleiro[idx][idx].Valor
	return sum

func sumDiag2():
	var sum = 0
	for idx in range(3):
		sum += Tabuleiro[idx][2 - idx].Valor
	return sum

func showWinDialog(caption, message):
	Winner = true
	WinDialog.window_title = caption
	WinDialog.dialog_text = message
	WinDialog.show()

func checkWin():
	for idx in range(3):
		var sum = sumRow(idx)
		if (sum == 3):
			showWinDialog("Player X Wins!", "Player X Wins in Row %d" % [idx + 1])
			return
		elif (sum == 30):
			showWinDialog("Player O Wins!", "Player O Wins in Row %d" % [idx + 1])
			return
		
		sum = sumCol(idx)
		if (sum == 3):
			showWinDialog("Player X Wins!", "Player X Wins in Column %d" % [idx + 1])
			return
		elif (sum == 30):
			showWinDialog("Player O Wins!", "Player O Wins in Column %d" % [idx + 1])
			return
	
	var d1 = sumDiag1()
	var d2 = sumDiag2()
	if (d1 == 3 or d2 == 3):
		showWinDialog("Player X Wins!", "Player X Wins in Diagonal")
		return
	elif (d1 == 30 or d2 == 30):
		showWinDialog("Player O Wins!", "Player O Wins in Diagonal")
		return

func onTileButtonPressed(button):
	if (ActivePlayer == ValX):
		if (Tabuleiro[button.Row][button.Col].Valor == 0):
			placeMark(button.Row, button.Col, ActivePlayer)

func aiFillRow(row):
	for col in range(3):
		if (Tabuleiro[row][col].Valor == 0):
			placeMark(row, col, ActivePlayer)

func aiFillCol(col):
	for row in range(3):
		if (Tabuleiro[row][col].Valor == 0):
			placeMark(row, col, ActivePlayer)

func aiFillDiag1():
	for idx in range(3):
		if (Tabuleiro[idx][idx].Valor == 0):
			placeMark(idx, idx, ActivePlayer)

func aiFillDiag2():
	for idx in range(3):
		if (Tabuleiro[idx][2 - idx].Valor == 0):
			placeMark(idx, 2 - idx, ActivePlayer)

func aiPicWinningFill():
	for idx in range(3):
		if (sumRow(idx) == 20):
			aiFillRow(idx)
			return true
		if (sumCol(idx) == 20):
			aiFillCol(idx)
			return true
	if (sumDiag1() == 20):
		aiFillDiag1()
		return true
	if (sumDiag2() == 20):
		aiFillDiag2()
		return true
	return false

func aiBlock():
	for idx in range(3):
		if (sumRow(idx) == 2):
			aiFillRow(idx)
			return true
		if (sumCol(idx) == 2):
			aiFillCol(idx)
			return true
	if (sumDiag1() == 2):
		aiFillDiag1()
		return true
	if (sumDiag2() == 2):
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
		if (Tabuleiro[row][col].Valor == 0):
			valido = true
		else:
			row = randi() % 3
			col = randi() % 3
	placeMark(row, col, ActivePlayer)

func onPlayAgain():
	clearTabuleiro()

func onQuit():
	get_tree().quit()
