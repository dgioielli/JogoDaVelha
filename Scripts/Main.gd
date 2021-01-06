extends Control

# Instâncias dos elementos da cena
onready var Tabuleiro = [
	[$Tiles/TileButton1, $Tiles/TileButton2, $Tiles/TileButton3],
	[$Tiles/TileButton4, $Tiles/TileButton5, $Tiles/TileButton6],
	[$Tiles/TileButton7, $Tiles/TileButton8, $Tiles/TileButton9]
]

onready var WinDialog = $WinDialog
onready var CTEs = $"/root/Ctes"
onready var CtrlGame = $"/root/CtrlGame"

# Sinais que podem ser emitidos
signal player_Changed(val)

# Variáveis de Base
var ActivePlayer = 0
var InactivePlayer = 0
var CurrentRound = 0
var Winner = false
var Multiplayer = false
var Pause = false

func _ready():
	_loadTabuleiro()
	_loadDialogBox()
	ActivePlayer = CTEs.ValX
	InactivePlayer = CTEs.ValO

func _input(event):
	if (event.is_action_pressed("Pause")):
		CtrlGame.Pause = not Pause

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
	ActivePlayer = CTEs.ValX
	for row in Tabuleiro:
		for btn in row:
			btn.reset()
	emit_signal("player_Changed", ActivePlayer)

func placeMark(row, col, player):
	if player == CTEs.ValX:
		Tabuleiro[row][col].setX(CTEs.ValX)
		ActivePlayer = CTEs.ValO
		InactivePlayer = CTEs.ValX
	else:
		Tabuleiro[row][col].setO(CTEs.ValO)
		ActivePlayer = CTEs.ValX
		InactivePlayer = CTEs.ValO
	
	CurrentRound += 1
	checkWin()
	emit_signal("player_Changed", ActivePlayer)
	
	if (CurrentRound == 9):
		showWinDialog("Draw!", "The game was a draw!")
		CtrlGame.Empates += 1
	elif (ActivePlayer == CTEs.ValO and not Winner and not Multiplayer):
		$Tween.interpolate_callback($Players/AiPlayer, 0.5 + randf(), "aiPicPoint")
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
			CtrlGame.VitoriasX += 1
			return
		elif (sum == 30):
			showWinDialog("Player O Wins!", "Player O Wins in Row %d" % [idx + 1])
			CtrlGame.VitoriasO += 1
			return
		
		sum = sumCol(idx)
		if (sum == 3):
			showWinDialog("Player X Wins!", "Player X Wins in Column %d" % [idx + 1])
			CtrlGame.VitoriasX += 1
			return
		elif (sum == 30):
			showWinDialog("Player O Wins!", "Player O Wins in Column %d" % [idx + 1])
			CtrlGame.VitoriasO += 1
			return
	
	var d1 = sumDiag1()
	var d2 = sumDiag2()
	if (d1 == 3 or d2 == 3):
		showWinDialog("Player X Wins!", "Player X Wins in Diagonal")
		CtrlGame.VitoriasX += 1
		return
	elif (d1 == 30 or d2 == 30):
		showWinDialog("Player O Wins!", "Player O Wins in Diagonal")
		CtrlGame.VitoriasO += 1
		return

func onTileButtonPressed(button):
	if (ActivePlayer == Ctes.ValX or Multiplayer):
		if (Tabuleiro[button.Row][button.Col].Valor == 0):
			placeMark(button.Row, button.Col, ActivePlayer)

func onPlayAgain():
	clearTabuleiro()

func onQuit():
	get_tree().quit()

func _on_BtnMenu_pressed():
	CtrlGame.Pause = true
	$CamadaOpcoes/Menu.visible = true

func _on_BtnResume_pressed():
	CtrlGame.Pause = false
	$CamadaOpcoes/Menu.visible = false

func _on_ChkMultiplayer_toggled(button_pressed):
	Multiplayer = button_pressed
	clearTabuleiro()
