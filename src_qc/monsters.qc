/************************************************************************************
***  Copyright (C) 1996-1997  Id Software, Inc.
***  Modifications Copyright (C) 2022  Boondorl
***
***  This program is free software: you can redistribute it and/or modify
***  it under the terms of the GNU General Public License as published by
***  the Free Software Foundation, either version 3 of the License, or
***  (at your option) any later version.
***
***  This program is distributed in the hope that it will be useful,
***  but WITHOUT ANY WARRANTY; without even the implied warranty of
***  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
***  GNU General Public License for more details.
***
***  You should have received a copy of the GNU General Public License
***  along with this program. If not, see https://www.gnu.org/licenses/gpl-3.0.html.
***
***  See file 'LICENSE' for details.
************************************************************************************/
/* ALL MONSTERS SHOULD BE 1 0 0 IN COLOR */

// name =[framenum,	nexttime, nextthink] {code}
// expands to:
// name ()
// {
//		self.frame=framenum;
//		self.nextthink = time + nexttime;
//		self.think = nextthink
//		<code>
// };

/*
// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten [Dawn]
================
by: Philip Martin aka: Kryten
When on top of monsters or players you slide. This is a QuakeC problem.
The function below fixes that problem.
based on code given to Kryten by: Michael Turitzin (MaNiAc)
================
*/
void() monster_touch =
{
	// can cause problems for monsters on top of a player, so only players
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	if ((!(other.flags & FL_ONGROUND)) && (other.absmin_z >= self.absmax_z - 2))
		other.flags |= FL_ONGROUND;

	// you can add other stuff like pushable players/monsters here
};

/*
================
monster_use

Using a monster makes it angry at the current activator
================
*/
void() monster_use =
{
	if (self.enemy)
		return;
	if (self.health <= 0)
		return;
	if (activator.items & IT_INVISIBILITY)
		return;
	if (activator.flags & FL_NOTARGET)
		return;
	if (activator.classname != "player")
		return;

	// delay reaction so if the monster is teleported, its sound is still
	// heard
	self.enemy = activator;
	FoundTarget(TRUE);
};

/*
================
monster_death_use

When a mosnter dies, it fires all of its targets with the current
enemy as activator.
================
*/
void() monster_death_use =
{
	// fall to ground
	if (self.flags & FL_FLY)
		self.flags = self.flags - FL_FLY;
	if (self.flags & FL_SWIM)
		self.flags = self.flags - FL_SWIM;

	if (!self.target)
		return;

	activator = self.enemy;
	SUB_UseTargets ();
};


//============================================================================

void() walkmonster_start_go =
{
	// raise off floor a bit
	self.origin_z = self.origin_z + 1;
	droptofloor();

	if (!walkmove(0,0))
	{
		dprint ("walkmonster in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}

	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 22.5;
	self.view_ofs = '0 0 25';
	self.use = monster_use;

	self.flags = self.flags | FL_MONSTER;

	if (self.target != string_null)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
		// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();
		else
		{
			self.pausetime = 99999999;
			self.th_stand ();
		}
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}

	// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
};


void() walkmonster_start =
{
	// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten [Dawn]
	self.touch = monster_touch;

	// delay drop to floor to make sure all doors have been spawned
	// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
	self.think = walkmonster_start_go;
	if (!self.is_zombie)
		total_monsters = total_monsters + 1;
};



void() flymonster_start_go =
{
	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 22.5;
	self.view_ofs = '0 0 25';
	self.use = monster_use;

	self.flags = self.flags | FL_FLY;
	self.flags = self.flags | FL_MONSTER;

	if (!walkmove(0,0))
	{
		dprint ("flymonster in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}

	if (self.target != string_null)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
		// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();
		else
		{
			self.pausetime = 99999999;
			self.th_stand ();
		}
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}
};

void() flymonster_start =
{
	// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten [Dawn]
	self.touch = monster_touch;

	// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
	self.think = flymonster_start_go;
	if (!self.is_zombie)
		total_monsters = total_monsters + 1;
};


void() swimmonster_start_go =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 22.5;
	self.view_ofs = '0 0 10';
	self.use = monster_use;

	self.flags = self.flags | FL_SWIM;
	self.flags = self.flags | FL_MONSTER;

	if (self.target != string_null)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
		// this used to be an objerror
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		self.th_walk ();
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}

	// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
};

void() swimmonster_start =
{
	// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten [Dawn]
	self.touch = monster_touch;

	// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
	self.think = swimmonster_start_go;
	if (!self.is_zombie)
		total_monsters = total_monsters + 1;
};
