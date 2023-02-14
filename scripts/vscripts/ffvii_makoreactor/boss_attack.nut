/*============================================================================================
									Zombie Spawn Script
----------------------------------------------------------------------------------------------
	* Author:	Eärendil
	* Version:	1.1
	* Desc:		Contains scripts for boss and bahamut entities for attaching
----------------------------------------------------------------------------------------------*/

function SetRandomPos()
{
	local float = 0.0;
	float = RandomFloat(0.0, 1.0);
	DoEntFire("!self", "SetPosition", float.tostring(), 0, self, self);
}

function SetRandomAtkCoords()
{
	local Vec = Vector(0, 0, -7036);
	Vec.x = RandomFloat(-2752.0, -2080.0);
	Vec.y = RandomFloat(364.0, 532.0);
	self.SetOrigin(Vec);
}

function RndBulletPos()
{
	local ent = null;
	ent = Entities.FindByName(ent, "Boss_shootrun");
	local Vec = Vector();
	Vec = ent.GetOrigin();
	Vec.x = Vec.x + RandomFloat(-16.0, 16.0);
	Vec.y = Vec.y + RandomFloat(-16.0, 16.0);
	Vec.z = -7036.0;
	self.SetOrigin(Vec);
}