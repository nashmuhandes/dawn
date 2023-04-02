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
	// note that we could use getstati to read the items stat, but it'd degrade when then cast to a float, and QSS + DP don't support ints, so we have to use two floats.
	citems 	= getstatbits(STAT_ITEMS, 0, 23);
	citems2 = getstatbits(STAT_ITEMS, 23, 9);
	cweapon = getstatf(STAT_ACTIVEWEAPON);
	chealth = getstatf(STAT_HEALTH);

	local vector drawPos;
	local vector picSize;
	local float drawPadding;

	// draw face
	picSize = '24 24 0';
	drawPadding = 8;
	drawPos = [drawPadding, viewsize_y - picSize_y - drawPadding];
	drawpic(drawPos, "gfx/face_100.lmp", picSize);

	// draw health
	drawPos = drawPos + [picSize_x + drawPadding];
	DrawNumber(drawPos, chealth, 0, "left");
};
