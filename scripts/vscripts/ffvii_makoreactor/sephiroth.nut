/*============================================================================================
									Sephiroth Script
----------------------------------------------------------------------------------------------
	* Author:	Eärendil
	* Version:	1.0
	* Desc:		Scripts related to Sephiroth entities
----------------------------------------------------------------------------------------------*/
SephHP <- 0.0;

function BridgeAttack()
{
	local Vec = Vector(0, -5392, -1376);
	Vec.x = RandomFloat(-4680.0, -4536.0);
	self.SetOrigin(Vec);
}

function RndAnimation()
{
	local rnd = RandomInt (1,3) * 2 - 1;
	local t = null;
	t = Entities.FindByName(t, "Seph_laser_timer");
	if (t != null)	//Prevent firing an output after timer death
	{
		DoEntFire("!self", "SetAnimation", "attack" + rnd.tostring(), 0, self, self);
	}
}

function LastAtk()
{
	local Vec = self.GetOrigin();
	Vec.x = Vec.x + RandomFloat(-16.0, 16.0);
	self.SetOrigin(Vec);
}

function SephHealth()
{
	local d = null;
	d = Entities.FindByName(d, "Director");
	local dScope = d.GetScriptScope();
	local p = null;
	local n = 0;
	while (p = Entities.FindByClassname(p, "player"))
	{
		if (p.IsSurvivor() && !IsPlayerABot(p))
		{
			if (!p.IsDead() || !p.IsDying())
			{
				n++;
			}
		}
	}
	if (dScope.MakoMasterLevel == 3)
	{
		SephHP = (1500.0 + 1000.0 * n);
	}
	else
	{
		SephHP = (2000.0 + 1200.0 * n);
	}
	self.SetHealth(SephHP);
}
function SephGlowColor()
{
	local NormHP = 0.0;
	local Model = null;
	Model = Entities.FindByName(Model, "Sephiroth_Dynamic_Bridge");
	NormHP = self.GetHealth() / SephHP;
	if (NormHP <= 0.9 && NormHP > 0.8)
	{
		DoEntFire ("!self", "SetGlowOverride", "255 255 125", 0, Model, Model);
	}
	if (NormHP <= 0.8 && NormHP > 0.65)
	{
		DoEntFire ("!self", "SetGlowOverride", "255 255 0", 0, Model, Model);
	}
	if (NormHP <= 0.65 && NormHP > 0.5)
	{
		DoEntFire ("!self", "SetGlowOverride", "255 200 0", 0, Model, Model);
	}
	if (NormHP <= 0.5 && NormHP > 0.35)
	{
		DoEntFire ("!self", "SetGlowOverride", "255 100 0", 0, Model, Model);
	}
	if (NormHP <= 0.35 && NormHP > 0.20)
	{
		DoEntFire ("!self", "SetGlowOverride", "255 50 0", 0, Model, Model);
	}
	if (NormHP <= 0.20)
	{
		DoEntFire ("!self", "SetGlowOverride", "255 0 0", 0, Model, Model);
	}
}