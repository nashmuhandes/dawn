// Contains code copied from https://github.com/whipowill/quake-mod-hud

//===========================================================================
//
// Prototypes
//
//===========================================================================

float() GetSBarAlpha;
void(vector pos, float value, float threshhold, string justify) DrawNumber;
void(vector viewsize) DrawHUD;
void(vector viewsize) DrawScores;

void() DrawDebug;

//===========================================================================
//
// Globals
//
//===========================================================================

// copies of stats, for easier access
float citems;		// copy of .items
float citems2;		// copy of .items2 (or serverflags)
float cweapon;		// copy of .weapon
float ccurrentammo;	// copy of .currentammo
float cweaponframe;	// copy of .weaponframe
float chealth;		// copy of .health
float carmorvalue;	// copy of .armorvalue

string SmallNumberPics[10] =
{
	"gfx/num_0",
	"gfx/num_1",
	"gfx/num_2",
	"gfx/num_3",
	"gfx/num_4",
	"gfx/num_5",
	"gfx/num_6",
	"gfx/num_7",
	"gfx/num_8",
	"gfx/num_9"
};

string BigNumberPics[10] =
{
	"gfx/anum_0",
	"gfx/anum_1",
	"gfx/anum_2",
	"gfx/anum_3",
	"gfx/anum_4",
	"gfx/anum_5",
	"gfx/anum_6",
	"gfx/anum_7",
	"gfx/anum_8",
	"gfx/anum_9"
};

//===========================================================================
//
// SERVER SIDE CONSTANTS
// (this shouldn't be a manual copy-paste...)
//
//===========================================================================

float	IT_AXE					= 4096;
float	IT_SHOTGUN				= 1;
float	IT_SUPER_SHOTGUN		= 2;
float	IT_NAILGUN				= 4;
float	IT_SUPER_NAILGUN		= 8;
float	IT_GRENADE_LAUNCHER		= 16;
float	IT_ROCKET_LAUNCHER		= 32;
float	IT_LIGHTNING			= 64;
float	IT_EXTRA_WEAPON			= 128;

float	IT_SHELLS				= 256;
float	IT_NAILS				= 512;
float	IT_ROCKETS				= 1024;
float	IT_CELLS				= 2048;

float	IT_ARMOR1				= 8192;
float	IT_ARMOR2				= 16384;
float	IT_ARMOR3				= 32768;
float	IT_SUPERHEALTH			= 65536;

float	IT_KEY1					= 131072;
float	IT_KEY2					= 262144;

float	IT_INVISIBILITY			= 524288;
float	IT_INVULNERABILITY		= 1048576;
float	IT_SUIT					= 2097152;
float	IT_QUAD					= 4194304;

//===========================================================================
//
// GetSBarAlpha
//
//===========================================================================

float() GetSBarAlpha =
{
	return autocvar(scr_sbaralpha, 1.0);
}

//===========================================================================
//
// DrawNumber
//
//===========================================================================

void(vector pos, float value, float threshhold, string justify) DrawNumber =
{
	float c;
	float len;
	string s;

	if (value < 0)
		value = 0;
	if (value > 999)
		value = 999;

	s = ftos(floor(value));
	len = strlen(s);

	if (justify == "right")
		pos_x -= 24 * len;

	if (value <= threshhold)
	{
		// use alternate (red) numbers
		while (len > 0)
		{
			len--;
			c = str2chr(s, len);
			drawpic(pos + [len * 24, 0], BigNumberPics[c - '0'], '24 24 0', '1 1 1', GetSBarAlpha(), 0);
		}
	}
	else
	{
		// use normal numbers
		while (len > 0)
		{
			len--;
			c = str2chr(s, len);
			drawpic(pos + [len * 24, 0], SmallNumberPics[c - '0'], '24 24 0', '1 1 1',  GetSBarAlpha(), 0);
		}
	}
};
