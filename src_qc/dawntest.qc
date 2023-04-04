/*
* Dawn Game Code
* Copyright (C) 2023 Nash Muhandes
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

//===========================================================================
//
// misc_dawntest
// A test entity to learn how to set up and animate static decorative models
//
//===========================================================================

void() misc_dawntestthink =
{
	self.frame += 1;
	if (self.frame == 26)
		self.frame = 1;
	self.nextthink = time + 0.1;
}

void() misc_dawntest =
{
	precache_model("progs/misc_dawntest.mdl");
	setmodel(self, "progs/misc_dawntest.mdl");
	setsize(self, '-32 -32 0', '32 32 38');

	self.solid = SOLID_SLIDEBOX;
	self.think = misc_dawntestthink;
	self.nextthink = time + 0.1;
	//misc_dawntestthink();

	// make this entity bleed (for testing purposes)
	//self.flags |= FL_MONSTER;
	//self.takedamage = DAMAGE_YES;

	// [Dawn] prevents player sliding when standing on top of it
	self.touch = monster_touch;

	// Once you make an entity static the model gets "baked" into the world and the edict is discarded, so you can't control it anymore
	//makestatic(self);
};
