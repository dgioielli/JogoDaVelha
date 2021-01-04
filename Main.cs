using Godot;
using System;

public class Main : Control
{
	#region Variáveis e Propriedades

	public TileButton[,] m_board = null;
	public AcceptDialog m_winDialog = null;

	public const int TileX = 1;
	public const int TileO = 10;

	public int m_currentRound = 0;
	public int m_activePlayer = TileX;
	public bool m_winner = false;

	#endregion

	// Declare member variables here. Examples:
	// private int a = 2;
	// private string b = "text";

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		loadBoard();
		
	}

	public void loadBoard()
	{
		m_board = new TileButton[,] 
		{
			{GetNode<TileButton>("Tiles/TileButton"), GetNode<TileButton>("Tiles/TileButton2"),
			 GetNode<TileButton>("Tiles/TileButton3")}, 
			{GetNode<TileButton>("Tiles/TileButton4"), GetNode<TileButton>("Tiles/TileButton5"),
			 GetNode<TileButton>("Tiles/TileButton6")}, 
			{GetNode<TileButton>("Tiles/TileButton7"), GetNode<TileButton>("Tiles/TileButton8"),
			 GetNode<TileButton>("Tiles/TileButton9")}
		};
		for (int i = 0; i < 3; i++)
			for (int j = 0; j < 3; j++)
			{
				m_board[i,j].Connect("customPressed", this, nameof(onTileButtonClicked));
				m_board[i,j].m_row = i;
				m_board[i,j].m_col = j;
				GD.Print($"Carregado ({i}, {j})");
			}
	}

	public void onTileButtonClicked(TileButton button)
	{
		if (m_activePlayer != TileX)
			return;
		GD.Print($"Pressed ({button.m_row}, {button.m_col})");
		if (m_board[button.m_row, button.m_col].m_value != 0)
			GD.Print("Already filled!");
			
	}

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
