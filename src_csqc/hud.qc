//===========================================================================
//
// CSQC_Init
//
//===========================================================================

void(float apilevel, string enginename, float engineversion) CSQC_Init =
{
	local float cpf = 0;
	local float i = 0;

	// precache number pics
	for (i = 0; i < 10; i++)
	{
		precache_pic(SmallNumberPics[i], cpf);
		precache_pic(BigNumberPics[i], cpf);
	}

	// precache HUD pics
	precache_pic("gfx/face_100.lmp", cpf);
}

//===========================================================================
//
// CSQC_DrawHud
//
//===========================================================================

void(vector viewsize, float scoresshown) CSQC_DrawHud =
{
	if (!scoresshown)
		DrawHUD(viewsize);
	else
		DrawScores(viewsize);

	if (cvar("developer"))
		DrawDebug();
};

//===========================================================================
//
// DrawHUD
//
//===========================================================================

void(vector viewsize) DrawHUD =
{
	// note that we could use getstati to read the items stat, but it'd degrade when then cast to a float, and QSS + DP don't support ints, so we have to use two floats.
	citems 	= getstatbits(STAT_ITEMS, 0, 23);
	citems2 = getstatbits(STAT_ITEMS, 23, 9);
	cweapon = getstatf(STAT_ACTIVEWEAPON);
	ccurrentammo = getstatf(STAT_AMMO);
	cweaponframe = getstatf(STAT_WEAPONFRAME);
	carmorvalue = getstatf(STAT_ARMOR);

	chealth = getstatf(STAT_HEALTH);

	local vector drawPos;
	local vector picSize;
	local float drawPadding;

	// draw face
	picSize = '24 24 0';
	drawPadding = 8;
	drawPos = [drawPadding, viewsize_y - picSize_y - drawPadding];
	drawpic(drawPos, "gfx/face_100.lmp", picSize, '1 1 1', GetSBarAlpha());

	// draw health
	drawPos = drawPos + [picSize_x + drawPadding];
	DrawNumber(drawPos, chealth, 0, "left");
}

//===========================================================================
//
// DrawScores
//
//===========================================================================

void(vector viewsize) DrawScores =
{
}

//===========================================================================
//
// DrawDebug
//
//===========================================================================

void() DrawDebug =
{
	drawfill('0 0 0', '1920 1080 0', '0 0 0', 0.8);

	local string txt;

	if (citems & IT_AXE)
		txt = strcat(txt, "IT_AXE ");
	if (citems & IT_SHOTGUN)
		txt = strcat(txt, "IT_SHOTGUN ");
	if (citems & IT_SUPER_SHOTGUN)
		txt = strcat(txt, "IT_SUPER_SHOTGUN ");
	if (citems & IT_NAILGUN)
		txt = strcat(txt, "IT_NAILGUN ");
	if (citems & IT_SUPER_NAILGUN)
		txt = strcat(txt, "IT_SUPER_NAILGUN ");
	if (citems & IT_GRENADE_LAUNCHER)
		txt = strcat(txt, "IT_GRENADE_LAUNCHER ");
	if (citems & IT_ROCKET_LAUNCHER)
		txt = strcat(txt, "IT_ROCKET_LAUNCHER ");
	if (citems & IT_LIGHTNING)
		txt = strcat(txt, "IT_LIGHTNING ");

	if (citems & IT_SHELLS)
		txt = strcat(txt, "IT_SHELLS ");
	if (citems & IT_NAILS)
		txt = strcat(txt, "IT_NAILS ");
	if (citems & IT_ROCKETS)
		txt = strcat(txt, "IT_ROCKETS ");
	if (citems & IT_CELLS)
		txt = strcat(txt, "IT_CELLS ");

	if (citems & IT_ARMOR1)
		txt = strcat(txt, "IT_ARMOR1 ");
	if (citems & IT_ARMOR2)
		txt = strcat(txt, "IT_ARMOR2 ");
	if (citems & IT_ARMOR3)
		txt = strcat(txt, "IT_ARMOR3 ");
	if (citems & IT_SUPERHEALTH)
		txt = strcat(txt, "IT_SUPERHEALTH ");

	if (citems & IT_KEY1)
		txt = strcat(txt, "IT_KEY1 ");
	if (citems & IT_KEY2)
		txt = strcat(txt, "IT_KEY2 ");

	if (citems & IT_INVISIBILITY)
		txt = strcat(txt, "IT_INVISIBILITY ");
	if (citems & IT_INVULNERABILITY)
		txt = strcat(txt, "IT_INVULNERABILITY ");
	if (citems & IT_SUIT)
		txt = strcat(txt, "IT_SUIT ");
	if (citems & IT_QUAD)
		txt = strcat(txt, "IT_QUAD ");

	local vector drawPos = '0 32 0';

	txt = sprintf("items: %s", txt);
	drawstring(drawPos, txt, '4 4');
	drawPos_y += 4;
	txt = "";

	txt = sprintf("serverflags: %d", citems2);
	drawstring(drawPos, txt, '4 4');
	drawPos_y += 4;
	txt = "";

	txt = sprintf("weapon: %d", cweapon);
	drawstring(drawPos, txt, '4 4');
	drawPos_y += 4;
	txt = "";

	txt = sprintf("currentammo: %d", ccurrentammo);
	drawstring(drawPos, txt, '4 4');
	drawPos_y += 4;
	txt = "";

	txt = sprintf("ammunition: %d %d %d %d", getstatf(STAT_SHELLS), getstatf(STAT_NAILS), getstatf(STAT_ROCKETS), getstatf(STAT_CELLS));
	drawstring(drawPos, txt, '4 4');
	drawPos_y += 4;
	txt = "";

	txt = sprintf("weaponframe: %d", cweaponframe);
	drawstring(drawPos, txt, '4 4');
	drawPos_y += 4;
	txt = "";

	txt = sprintf("armorvalue: %d", carmorvalue);
	drawstring(drawPos, txt, '4 4');
	drawPos_y += 4;
	txt = "";
}
