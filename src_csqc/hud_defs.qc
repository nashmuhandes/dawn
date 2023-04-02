// Contains code copied from https://github.com/whipowill/quake-mod-hud

//===========================================================================
//
// Prototypes
//
//===========================================================================

void(vector pos, float value, float threshhold, string justify) DrawNumber;

//===========================================================================
//
// Globals
//
//===========================================================================

// copies of stats, for easier access
float citems;	// copy of .items
float citems2;	// copy of .items2 (or serverflags)
float cweapon;	// copy of .weapon
float chealth;	// copy of .health

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
			drawpic(pos + [len * 24, 0], BigNumberPics[c - '0'], '24 24 0', '1 1 1', 1, 0);
		}
	}
	else
	{
		// use normal numbers
		while (len > 0)
		{
			len--;
			c = str2chr(s, len);
			drawpic(pos + [len * 24, 0], SmallNumberPics[c - '0'], '24 24 0', '1 1 1', 1, 0);
		}
	}
};
