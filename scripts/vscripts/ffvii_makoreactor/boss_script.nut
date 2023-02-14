/*============================================================================================
									Boss Script
----------------------------------------------------------------------------------------------
	* Author:	Eärendil
	* Version:	1.0
	* Desc:		Sets boss health and sets glowing color based on health remaining
----------------------------------------------------------------------------------------------*/

Director	<- EntityGroup[0];		// Director is needed to get game level
Boss 		<- EntityGroup[1];		// This is the boss and the bahamut hitbox
Model		<- EntityGroup[2];		// Boss and Bahamut prop_dynamic
Model_2		<- 0;		// Boss cargo prop_dynamic
level		<- 0;
BossHP		<- 0.0;

function GetGameLevel()
{
	if(Director.ValidateScriptScope())
	{
		local dScope = Director.GetScriptScope();
		level = dScope.MakoMasterLevel;
	}
	if (level < 3)
	{
		Model_2	<- EntityGroup[3];
	}
}

function SetBossGlowColor()
{
	local NormBossHP = 0.0		// This value will be from 0.0 to 1.0, where 1.0 = 100% health 0.5 = 50% and so on
	NormBossHP = Boss.GetHealth() / BossHP;
	if (NormBossHP <= 0.9 && NormBossHP > 0.8)
	{
		DoEntFire ("!self", "SetGlowOverride", "255 255 125", 0, Model, Model);
		DoEntFire ("!self", "SetGlowOverride", "255 255 125", 0, Model_2, Model_2);
	}
	if (NormBossHP <= 0.8 && NormBossHP > 0.65)
	{
		DoEntFire ("!self", "SetGlowOverride", "255 255 0", 0, Model, Model);
		DoEntFire ("!self", "SetGlowOverride", "255 255 0", 0, Model_2, Model_2);
	}
	if (NormBossHP <= 0.65 && NormBossHP > 0.5)
	{
		DoEntFire ("!self", "SetGlowOverride", "255 200 0", 0, Model, Model);
		DoEntFire ("!self", "SetGlowOverride", "255 200 0", 0, Model_2, Model_2);
	}
	if (NormBossHP <= 0.5 && NormBossHP > 0.35)
	{
		DoEntFire ("!self", "SetGlowOverride", "255 100 0", 0, Model, Model);
		DoEntFire ("!self", "SetGlowOverride", "255 100 0", 0, Model_2, Model_2);
	}
	if (NormBossHP <= 0.35 && NormBossHP > 0.20)
	{
		DoEntFire ("!self", "SetGlowOverride", "255 50 0", 0, Model, Model);
		DoEntFire ("!self", "SetGlowOverride", "255 50 0", 0, Model_2, Model_2);
	}
	if (NormBossHP <= 0.20)
	{
		DoEntFire ("!self", "SetGlowOverride", "255 0 0", 0, Model, Model);
		DoEntFire ("!self", "SetGlowOverride", "255 0 0", 0, Model_2, Model_2);
	}
}

function SetBossHeal()
{
	local survivorcount = 0
	local humancount = 0
	local BaseHP = 0.0
	local SurvivorAddsHP = 0
	local ActivePlayerAddsHP = 0
	local i = null
	
	GetGameLevel();
	if (level == 1)
	{
		BaseHP = 10000.0
		SurvivorAddsHP = 3000
		ActivePlayerAddsHP = 1000
	}
	if (level == 2)
	{
		BaseHP = 12000.0
		SurvivorAddsHP = 3500
		ActivePlayerAddsHP = 1250
	}
	if (level == 3)
	{
		BaseHP = 15000.0
		SurvivorAddsHP = 4000
		ActivePlayerAddsHP = 1500
	}
	if (level == 4)
	{
		BaseHP = 18000.0
		SurvivorAddsHP = 5000
		ActivePlayerAddsHP = 2000
	}
	if (level == 5)
	{
		BaseHP = 20000.0
		SurvivorAddsHP = 6500
		ActivePlayerAddsHP = 3000
	}
	while (i = Entities.FindByClassname(i, "player"))
	{
		if (i.IsSurvivor() && !(i.IsDead() || i.IsDying()))
		{
			if (!IsPlayerABot(i))
			{
				humancount++;
			}
			survivorcount++;
		}
	}
	BossHP = BaseHP + (SurvivorAddsHP * survivorcount) + (ActivePlayerAddsHP * humancount);
	Boss.SetHealth(BossHP);
}