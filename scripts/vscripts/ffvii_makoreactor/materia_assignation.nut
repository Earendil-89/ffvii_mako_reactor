/*============================================================================================
									Materia Check Script
----------------------------------------------------------------------------------------------
	* Author:	Eärendil
	* Version:	1.0
	* Desc:		Checks if player is carrying a materia, to parent only one per player
----------------------------------------------------------------------------------------------*/

NamesArr <- ["Null", "CarrierFire", "CarrierIce", "CarrierHeal", "CarrierThunder", "CarrierShield", "CarrierHaste", "CarrierVoid", "CarrierUltima"];
EntSpwnArr <- ["Null", "M_Fire_ParentSpwn", "M_Ice_ParentSpwn", "M_Heal_ParentSpwn", "M_Thunder_ParentSpwn", "M_Shield_ParentSpwn", "M_Haste_ParentSpwn", "M_Void_ParentSpwn", "M_Ultima_ParentSpwn"];

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
				if (!("PretendMateria" in pScope))
				{
					pScope.PretendMateria <- null;
					pScope.HasMateria <- false;
				}
			}
		}
	}
}

function InitializePickMateria(value)
{
	BuildPlayerVariables();
	DoEntFire("!self", "RunScriptCode", "PretendMateria <- " + value.tostring(), 0, activator, activator);
}

function TryParentMateria(value)
{
	local p = null; 
	while((p = Entities.FindByClassname(p, "player")) != null)
	{
	    if (p.IsValid() && p.IsSurvivor())
		{
			if (p.ValidateScriptScope())
			{
				local pScope = p.GetScriptScope();
				if (pScope.PretendMateria == value && pScope.HasMateria == false)
				{
					DoEntFire("!self", "AddOutput", "Targetname " + NamesArr[value], 0, p, p);
					DoEntFire("!self", "AddOutput", "Targetname MateriaCarrier", 0.25, p, p);
					DoEntFire("!self", "Kill", "", 0, self, self);
					SpawnParentScript(value);
					pScope.HasMateria <- true;
					break;
				}
			}
		}
	}
}

function SpawnParentScript(value)
{
	DoEntFire (EntSpwnArr[value], "ForceSpawn", "", 0.05, self, self);
}