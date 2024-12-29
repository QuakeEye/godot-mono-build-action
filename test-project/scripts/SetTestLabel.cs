using Godot;
using System;

public partial class SetTestLabel : RichTextLabel
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
		=> Text = $"Current time: {DateTime.Now.ToString("HH:mm:ss")}";
}
