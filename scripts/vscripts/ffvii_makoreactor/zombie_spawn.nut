/*============================================================================================
									Zombie Spawn Script
----------------------------------------------------------------------------------------------
	* Author:	Eärendil
	* Version:	1.1
	* Desc:		Spawns zombies if its under custom spawn limit,
				(spawn limit are set in the main script)
----------------------------------------------------------------------------------------------*/

CommonLimit <- -1
TankLimit <- -1

function GetZombieLimits()
{
	local d = null
	local dScope = null
	d = Entities.FindByName(d, "Director")
	{
		if (d.IsValid() && d.ValidateScriptScope())
		dScope = d.GetScriptScope();
		if (dScope.MakoMasterLevel == 1)
		{
			TankLimit = 0;
			CommonLimit = 20;
		}
		if (dScope.MakoMasterLevel == 2)
		{
			TankLimit = 1;
			CommonLimit = 30;
		}
		if (dScope.MakoMasterLevel == 3)
		{
			TankLimit = 1;
			CommonLimit = 40;
		}
		if (dScope.MakoMasterLevel == 4)
		{
			TankLimit = 2;
			CommonLimit = 40;
		}
		if (dScope.MakoMasterLevel == 5)
		{
			TankLimit = 3;
			CommonLimit = 50;
		}
	}
}


function GetCICount()
{
	local n = 0
	local i = null
	while (i = Entities.FindByClassname(i, "infected"))
	{
		n++;
	}
	return n;
}

function GetTankCount()
{
	local n = 0
	local i = null
	while (i = Entities.FindByClassname(i, "player"))
	{
		if (i.IsValid() && !i.IsSurvivor() && i.GetZombieType() == 8)
		{
			if (!i.IsDead() && !i.IsDying())
			{
				n++;
			}
		}
	}
	return n;
}

function CommonSpawn()
{
	if (CommonLimit == -1)
	{
		GetZombieLimits();
	}
	if (GetCICount() < CommonLimit)
	{
		DoEntFire ("!self", "SpawnZombie", "0", 0, self, self);
	}
}

function WarpCommons()
{
	local Vec = self.GetOrigin();
	local i = null;
	while (i = Entities.FindByClassname(i, "infected"))
	{
		i.SetOrigin(Vec);
	}
}


function TankSpawn()
{
	if (TankLimit == -1)
	{
		GetZombieLimits();
	}
	if (GetTankCount() < TankLimit)
	{
		DoEntFire ("!self", "SpawnZombie", "tank", 0, self, self);
		printl("TANK SPAWNED");
	}
}