/*============================================================================================
									Area Manager Script
----------------------------------------------------------------------------------------------
	* Author:	Eärendil
	* Version:	1.0
	* Desc:		Manages where are players/bots and teleport them to the right area
----------------------------------------------------------------------------------------------*/
function BuildPlayerVariables()
{
	local p = null; 
	while((p = Entities.FindByClassname(p, "player")) != null)
	{
	    if (p.IsValid() && p.IsSurvivor())
		{
			if (p.ValidateScriptScope())
			{
				local pScope = p.GetScriptScope();
				if (!("CurrentArea" in pScope))
				{
					pScope.CurrentArea <- 0;
				}
			}
		}
	}
}

function TeleportLateSurvivors(area, vector, forcehumans)
{
	local level = null;
	local d = null;
	d = Entities.FindByName(d, "Director");
	// Get game level while its stored inside the info_director 
	{
		if (d.IsValid() && d.ValidateScriptScope())
		{
			local dScope = d.GetScriptScope();
			level = dScope.MakoMasterLevel;
		}
	}
	local p = null;
	local pos = Vector(); 
	while ((p = Entities.FindByClassname(p, "player")) != null)
	{
		if (p.IsSurvivor() && p.ValidateScriptScope())
		{
			local pScope = p.GetScriptScope();
			pos = p.GetOrigin();
			if (IsPlayerABot(p) && pScope.CurrentArea < area)
			{
				KillNearChargers(pos);
				p.SetOrigin(vector);
				pScope.CurrentArea = area;
			}
			if (!IsPlayerABot(p) && pScope.CurrentArea < area && (level <= 2 || forcehumans = true))
			{
				KillNearChargers(pos);
				p.SetOrigin(vector);
				pScope.CurrentArea = area;				
			}
		}
	}
}

function CheckPlayersInArea(area)
{
	local i = null;
	local StillInArea = false;
	while ((i = Entities.FindByClassname(i, "player")) != null)
	{
		local pScope = i.GetScriptScope();
		if (i.IsSurvivor() && !IsPlayerABot(i) && !i.IsDead() && !i.IsDying() && pScope.CurrentArea <= area)
		{
			StillInArea = true;
		}
	}
	if (!StillInArea)
	{
		DoEntFire("!self", "FireUser1", "", 0, caller, caller);		// Using activator instead of caller also fires an output to the last entity in the I/O chain
	}
}

// If chargers have pummeled a survivor he will not teleported, so kill them before
function KillNearChargers(vector)
{
	local i = null;
	while ((i = Entities.FindByClassnameWithin(i, "player", vector, 128)) != null)
	{
		if (i.IsValid() && !i.IsSurvivor() && i.GetZombieType() == 6)
		{
			i.TakeDamage(50000.0, 0, i);
		}
	}
}