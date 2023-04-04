//===========================================================================
//
// misc_blood
// Doom-style blood splat
//
//===========================================================================

void() s_blood1 = [0, s_blood2] { self.nextthink = time + 0.2 + (random() * 0.1); };
void() s_blood2 = [1, s_blood3] { self.nextthink = time + 0.1 + (random() * 0.1); };
void() s_blood3 = [2, s_blood4] { self.nextthink = time + 0.1 + (random() * 0.1); };
void() s_blood4 = { SUB_Remove(); };

//===========================================================================
//
//
//
//===========================================================================

void(entity e, vector org) BloodSplat =
{
	local entity blud = spawn();

	blud.classname = "misc_blood";
	blud.owner = e;
	blud.solid = SOLID_NOT;
	blud.movetype = MOVETYPE_TOSS;

	setmodel(blud, "progs/blud.spr");
	setsize(blud, '-2 -2 0', '2 2 4');
	blud.scale = 0.666 + (0.0666 * random());

	setorigin(blud, org);
	blud.velocity_z = 100 * crandom();
	blud.velocity_x = -80 + (random() * 160);
	blud.velocity_y = -80 + (random() * 160);

	// self must be set to the entity for animation to work properly
	// save the original pointer then restore it back after the animation call
	local entity old_self = self;
	self = blud;
	s_blood1();
	self = old_self;
};
