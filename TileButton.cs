using Godot;
using System;

public class TileButton : TextureButton
{
	#region Variáveis e Propriedades

	public Texture oTex = GD.Load("res://OGlow.png") as Texture;
	public Texture xTex = GD.Load("res://XGlow.png") as Texture;
	public Texture hoverTex = GD.Load("res://Hover.png") as Texture;

	public int m_value = 0;
	[Export]
	public int m_row = -1;
	[Export]
	public int m_col = -1;

	[Signal]
	public delegate void customPressed(TileButton button);

	#endregion
	
	public override void _Ready()
	{ 
		this.Connect("pressed", this, nameof(onTileButtonPressed));
		reset(); 
	}

	private void reset()
	{ atuzlizar(null, hoverTex); }

	public void setX(int val = Main.TileX)
	{ atuzlizar(xTex, xTex, val); }

	public void setO(int val = Main.TileO)
	{ atuzlizar(oTex, oTex, val); }

	private void atuzlizar(Texture normal, Texture hover, int val = 0)
	{
		m_value = val;
		base.TextureNormal = normal;
		base.TextureHover = hover;
	}

	private void onTileButtonPressed()
	{
		GD.Print($"Emitido o sinal de {nameof(customPressed)}");
		EmitSignal(nameof(customPressed));
	}
}
