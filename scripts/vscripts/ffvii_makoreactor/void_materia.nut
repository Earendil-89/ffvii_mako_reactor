/*============================================================================================
									Void Materia Script
----------------------------------------------------------------------------------------------
	* Author:	Eärendil
	* Version:	1.0
	* Desc:		Void Materia has its own file due to raytrace
----------------------------------------------------------------------------------------------*/

Materia		<- EntityGroup[0];			// This is the func_brush entity, used to get where is the player when casting the materia
Target		<- EntityGroup[1];			// Void target for raytrace (im too lazy to write the code for a vector, I will use a map entity)
Spawner		<- EntityGroup[2];
VoidVector	<- Vector();
dist		<- 420;						// Distance in Hammer Units between start and end entities

traceTable <-						// RayTrace table for tracing a good spot for void materia
{
	start = Vector()
	end = Vector()
	mask = null
}

function TraceVoid()		// Raytrace to prevent the void is inside a solid or outside the map
{
	traceTable.start = Materia.GetOrigin() + Vector(0,0,32);
	traceTable.end = Target.GetOrigin() + Vector(0,0,32);
	traceTable.mask = 1;
	TraceLine(traceTable);
	if (traceTable.fraction > 0.35) // Only spawn void if its further than this distance
	{
		local NormVector = Vector();
		NormVector = (traceTable.end - traceTable.start)* (1.0/dist);
		VoidVector = traceTable.start + (NormVector * dist * (traceTable.fraction - 0.15));
		Spawner.SetOrigin(VoidVector + Vector(0,0,32));
		DoEntFire("M_Void_Logic", "Trigger", "", 0, self, self);
	}
}