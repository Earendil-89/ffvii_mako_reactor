/*============================================================================================
									Entity Parent Script
----------------------------------------------------------------------------------------------
	* Author:	Eärendil
	* Version:	1.0
	* Desc:		Makes an entity follow a player with rotation only in Z-axis
----------------------------------------------------------------------------------------------*/
Player <- EntityGroup[0];
Children <- EntityGroup[1];
PlayerCoords <- Vector(0,0,0);
PlayerAngles <- Vector(0,0,0);

function Think()
{
	if (!Player.IsValid())		// If player leaves game, remove children
	{
		DoEntFire("!self", "Kill", "", 0, Children, Children);
		DoEntFire("!self", "Kill", "", 0, self, self);
		return;
	}
	if (Player.IsDead() || Player.IsDying())	// If player has died remove children temporaly until player respawns
	{
		Children.SetOrigin(Vector(0,0,0));
		return;
	}
	PlayerCoords = Player.EyePosition() - Vector(0,0,56);
	PlayerAngles = Player.GetAngles();
	Children.SetAngles(PlayerAngles);
	Children.__KeyValueFromVector("origin", PlayerCoords);
}

function FreeUser()				// When Ultima is casted, carrier is able to pick another materia
{
	if (Player.IsValid() && Player.ValidateScriptScope())
	{
		local pScope = Player.GetScriptScope();
		pScope.PretendMateria <- null;
		pScope.HasMateria <- false;
	}
}