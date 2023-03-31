/*======================================================================
 All CSQC functions (Vanilla ONLY version)

 * This file is heavily influenced by QSS devkit (credit=spike)
 * re-written some functions to make better sense to me
 * Contains all HUD elements for full quake interface (SP/Coop/Dm)
 * Sripped out the experimental stuff included in devkit
 * Converted most of the hardcoded values into constants
 * Added loads of extra comments to show what is going on

======================================================================*/
float nocsqc;				// CSQC State (0=on, 1=off)
float detectDP;				// Detect DP engine (using wrapper)
float sitems;				// CSQC copy of .items
float sitems2;				// CSQC copy of .items2 (or serverflags)
float sweapon;				// CSQC copy of .weapon
float shealth;				// CSQC copy of .health

float sb_showscores;		// Show lower tab scores
float painfinishtime;		// Track player damage for hud face

float intermission;			// in intermission
float intermission_time;	// when the intermission started

float player_localentnum;	// Entity number that csqc is attached to
float numclientseats;		// coop or splitscreen?
float maxclients;			// maximum players possible on this server
float cltime;				// increases regardless of pause or game speed

.float ext_csqc;			// Client Server Quake C HUD alive!
string CSQC_PING = "csqcping";	// Test command to check if CSCQ alive

// Default sizes for HUD elements
vector HUDSIZE_320 = '320 24 0';	// Background images
vector HUDSIZE_24 = '24 24 0';		// Status Bar
vector HUDSIZE_16 = '16 16 0';		// Inventory/Powerups
vector HUDSIZE_816 = '8 16 0';		// Runes
vector HUDSIZE_8  = '8 8 0';		// Ammo numbers
vector HUDSIZE_C8 = '8 0 0';		// Character sizes

// 8 pixel font table (index positions)
float HUDFONT_WHITE = 0;	// Default index = 48-57
float HUDFONT_YELLOW = 1;	// index = index - 30
float HUDFONT_RED = 2;		// index = index + 128

// Default sizes for weapons
vector HUDWPN_48 = '48 16 0';		// Vanilla LG
vector HUDWPN_32 = '32 16 0';		// AD/Hipnotic LG
vector HUDWPN_24 = '24 16 0';		// Default

vector HUDRGB_DEF = '1 1 1';
float baralpha;				// Read scr_sbaralpha variable
float hudalpha;				// All gfx on hud bars

//----------------------------------------------------------------------
// These constants are only used in CSQC_UpdateView
float MASK_ENGINE = 1;
float MASK_VIEWMODEL = 2;
float VF_MIN = 1;
float VF_SIZE = 4;
float VF_DRAWENGINESBAR = 20;
float VF_DRAWCROSSHAIR = 21;

//----------------------------------------------------------------------
// Stubs for extra CSQC functions (not all supported)
//----------------------------------------------------------------------
// Can query or check anything types on the console here
float(string str) CSQC_ConsoleCommand =
{
	tokenize_console(str);
	return FALSE;
};
// Can query/check keyboard/mouse/joystick input with this function
// For key events, scanx is one of the KEY_* values
// chary is the character code (chr2str to shove it into a string)
// For mouse events then x+y are the mouse delta/position values
float(float evtype, float scanx, float chary, float devid) CSQC_InputEvent =
{
	return FALSE;
};

// This is linked to client dmg_take / dmg_save / dmg_inflictor fields
// returning TRUE will block the red flash damage stuff
float(float save, float take, vector dir) CSQC_Parse_Damage =
{
	painfinishtime = time + 0.2;
	return FALSE;
};

// Can query/check server MSG events
// CSQC_Parse_Event is called when the client sees a
// #define svcfte_cgamepacket (83) message from the server
// Not supported for DP, is called from only QSS/FTE
void() CSQC_Parse_Event =
{
};

// Can intercept printed messages from the server (top of screen)
// printlvl (text filtering) 0=low, 1=medium, 2=high, 3=chat
// con_notifytime = amount of time the text remains on screen
// ONLY define this function, if doing something with the text!!
void(string printmsg, float printlvl) CSQC_Parse_Print =
{
	print(printmsg);
};

// Running on the Server side of CSCQ listening for commands back
// This is never called on the client side of the progs
void(string str) SV_ParseClientCommand =
{
	local string ostr, cmd;
	// Save command string for later
	ostr = str;
	// Search for tokens in string
	tokenize_console(str);
	// Find the first argument of the command
	cmd = argv(0);
	// Is this my (AD CSQC) command?
	if (cmd == CSQC_PING) self.ext_csqc = TRUE;
	// Pass through original command
	else clientcommand(self, ostr);
};

//======================================================================
// MAIN ENTRY POINT FOR HUD!!!
//----------------------------------------------------------------------

void(vector virtsize, float showscores) CSQC_DrawHud =
{
	string face;
	face = "gfx/face_100.lmp";
	//drawpic((0, 200), face, HUDSIZE_24, HUDRGB_DEF, 1.0, 0);
};

//----------------------------------------------------------------------
void(vector virtsize, float showscores) CSQC_DrawScores =
{
};

//----------------------------------------------------------------------
void(float vwidth, float vheight, float notmenu) CSQC_UpdateView =
{
	local vector ssize;
	ssize_x = vwidth; ssize_y = vheight; ssize_z = 0;


	clearscene();
	addentities(MASK_ENGINE|MASK_VIEWMODEL);

	setproperty(VF_MIN, '0 0');
	setproperty(VF_SIZE, ssize);

	setproperty(VF_DRAWENGINESBAR, FALSE);

	setproperty(VF_DRAWCROSSHAIR, TRUE);

	renderscene();

	// Draw the HUDs and scoreboards
	CSQC_DrawHud(ssize, sb_showscores);
	CSQC_DrawScores(ssize, sb_showscores);
};

//----------------------------------------------------------------------
// Registers HUD gfx images (all setup in string arrays)
//----------------------------------------------------------------------
void(float apilevel, string enginename, float engineversion) CSQC_Init =
{
	precache_pic("gfx/face_100.lmp", FALSE);
};
