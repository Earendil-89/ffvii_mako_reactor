/*============================================================================================
									Materia Core Script
----------------------------------------------------------------------------------------------
	* Author:	Eärendil
	* Version:	1.3
	* Desc:		All materias power are here (some of them are in map itself)
----------------------------------------------------------------------------------------------*/

Level 		<- 0;						// Materias level, 
BahaOnGame <- false;
ShieldCount <- 0;
	
function GetMateriasLevel()
{
	local Director = Entities.FindByName(Director, "Director");
	if(Director.ValidateScriptScope())
	{
		local dScope = Director.GetScriptScope();
		Level = dScope.MakoMateriasLevel;
	}
}


function CheckBahaInGame()
{
	local ent = null;
	while (ent = Entities.FindByName(ent, "Baha_hitbox"))
	{
		BahaOnGame <- true;
	}
	if (BahaOnGame)
	{
		DoEntFire ("!self", "FireUser1", "0", 0, self, self);
	}
}

function DamageBahamut(dmg)
{
	local i = null
	local BahaHP = 0.0;
	i = Entities.FindByName(i, "Baha_hitbox");
	if (i.IsValid())
	{
		BahaHP = i.GetHealth();
		if (BahaHP <= dmg)
		{
			DoEntFire ("!self", "Break", "0", 0, i, i);
		}
		else
		{
			BahaHP = BahaHP - dmg;
			i.SetHealth(BahaHP);
		}
	}
}

function EnableThunderParticles()
 {
	GetMateriasLevel();
	if (Level == 2)
	{
		DoEntFire ("M_Thunder_Charge1", "Stop", "0", 0, self, self);
		DoEntFire ("M_Thunder_Charge2", "Start", "0", 0, self, self);
		DoEntFire ("M_Thunder_Charge3", "Start", "0", 0, self, self);
	}
	if (Level == 3)
	{
		DoEntFire ("M_Thunder_Charge2", "Start", "0", 0, self, self);
		DoEntFire ("M_Thunder_Charge3", "Start", "0", 0, self, self);	 
	} 
 }
 
function MFireBurn()
{
	local i = null
	local j = null
	local coordinates = Vector()
	local ent = null
	ent = Entities.FindByName(ent, "M_Fire_Parent");
	coordinates = ent.GetOrigin();
	while (i = Entities.FindByClassnameWithin(i, "player", coordinates, 3072))
	{
		if (!i.IsSurvivor())
		{
			DoEntFire ("!self", "Ignite", "0", 0, i, i);
		}
	}
	while (j = Entities.FindByClassnameWithin(i, "infected", coordinates, 3072))
	{
		{
			DoEntFire ("!self", "Ignite", "0", 0, j, j);
		}
	}	
}

function MHeal(maxHP, amount, radius)
{
	local player = null
	local coordinates = Vector(0,0,0)
	local ent = null
	ent = Entities.FindByName(ent, "M_Heal_Parent");
	coordinates = ent.GetOrigin();
	while (player = Entities.FindByClassnameWithin(player, "player", coordinates, radius))
	{
		if (player.IsSurvivor())
		{
			player.SetReviveCount(0);
			local currenthp = null
			local targethp = null
			currenthp = player.GetHealth();
			if (player.IsIncapacitated())
			{
				player.ReviveFromIncap();
			}
			if (currenthp < maxHP)
			{
				targethp = currenthp + amount;
				player.SetHealth(targethp);
				player.SetReviveCount(0);
			}
			else if (currenthp < maxHP && currenthp >= (maxHP - amount))
			{
				player.SetHealth(maxHP);
			}
		}
	}
}

function MHealTeleDeadPlayers()
{
	local survdeathmmod = null
	local destination = Vector()
	local ent = null
	ent = Entities.FindByName(ent, "M_Heal_Parent");
	destination = ent.GetOrigin();
	while (survdeathmmod = Entities.FindByClassname(survdeathmmod, "survivor_death_model"))
	{
		survdeathmmod.SetOrigin(destination);
	}
}

function MHealResurrect()
{
	local i = null
	while (i = Entities.FindByClassname(i, "player"))
	{
		if (i.IsSurvivor())
		{
			if (i.IsDead() || i.IsDying())
			{
				i.ReviveByDefib();
			}
		}
	}
}

function MVoid()
{
	local VoidSI = null
	local VoidCI = null
	local VoidCoords = Vector()
	local VoidCenter = null
	VoidCenter = Entities.FindByName(VoidCenter, "M_Void_Particle")
	{
		VoidCoords = VoidCenter.GetOrigin();
	}
	while (VoidSI = Entities.FindByClassnameWithin(VoidSI, "player", VoidCoords, 450))
	{
		if (!VoidSI.IsSurvivor() && VoidSI.GetName() != "BotTarget") 		// There is a jockey called "BotTarget" inside the boss to asist survivor bots, this prevents to teleport it outside the boss
		{
			VoidSI.SetOrigin(VoidCoords);
			VoidSI.Stagger(Vector());
		}
	}
	while (VoidCI = Entities.FindByClassnameWithin (VoidCI, "infected", VoidCoords, 450))
	{
		VoidCI.SetOrigin(VoidCoords);
	}
}

function MHasteSpeed()
{
	local playertohaste = null
	local coordinates = Vector(0,0,0)
	local hasteorigin = null
	hasteorigin = Entities.FindByName(hasteorigin, "M_Haste_Parent")
	{
		coordinates = hasteorigin.GetOrigin();
	}
	while (playertohaste = Entities.FindByClassnameWithin(playertohaste, "player", coordinates, 400))
	{
		if (playertohaste.IsSurvivor())
		{
			playertohaste.UseAdrenaline(40)
		}
	}
}

function MShieldCheck()
{
	if (activator.IsValid())
	{
		if (activator.GetClassname() == "infected")
		{
			MShieldDecrease(1);
			activator.TakeDamage(50.0, 0, activator);
			return;
		}
		else if (!activator.IsSurvivor())
		{
			if (!activator.IsDead() && !activator.IsDying())
			{
				if (activator.GetZombieType() < 8)
				{
					MShieldDecrease(3);
					activator.TakeDamage(10000.0, 0, activator);
				}
				else
				{
					MShieldDecrease(6);
					activator.TakeDamage(3500.0, 0, activator);
				}
			}
		}
	}
}

function MShieldDecrease(amount)
{
	if (ShieldCount > amount)
	{
		ShieldCount = ShieldCount - amount;
	}
	else
	{
		ShieldCount = 0;
		DoEntFire("!self", "FireUser1", "", 0, self, self);
	}
}

function MThunder()
{
	if (!self.IsValid())
	{
		return;
	}
	local Vec = self.GetOrigin()
	local z = null;
	while (z = Entities.FindByClassnameWithin(z, "player", Vec, 288))
	{
		if (z.IsValid() && !z.IsSurvivor())
		{
			if (z.GetZombieType() == 8)
			{
				z.TakeDamage(250.0, 0, z);
			}
			if (z.GetZombieType() == 6)
			{
				z.TakeDamage(125.0, 0, z);
			}
			else
			{
				z.TakeDamage(30.0, 0, z);
			}
		}
	}
	DoEntFire("!self", "RunScriptCode", "MThunder()", 0.25, self, self);
}