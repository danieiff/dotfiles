#pragma once

#define SELECT_SOFT_SERIAL_SPEED 1
/*Sets the protocol speed when using serial communication*/
//Speeds:
//0: about 189kbps (Experimental only)
//1: about 137kbps (default)
//2: about 75kbps
//3: about 39kbps
//4: about 26kbps
//5: about 20kbps

#define MASTER_LEFT

#undef TAPPING_TERM
#define TAPPING_TERM 180 // Time before hold starts
#define TAPPING_TOGGLE 2 // for some Tap Toggle actions such as 'TT(layer)'

#define ONESHOT_TIMEOUT 5000
#define ONESHOT_TAP_TOGGLE 2 // locks the One Shot key

#define MOUSEKEY_MOVE_DELTA 4
#define MOUSEKEY_INTERVAL 16

#define AUTO_SHIFT_MODIFIERS // Enable Auto Shift for 1 or more modifier keys press.
#define AUTO_SHIFT_TIMEOUT 180 // Holding for this time will get Shifted.

#define DYNAMIC_MACRO_NO_NESTING // Safety for Dynamic Macro prevents recursive invoking

#define UNICODE_SELECTED_MODES UNICODE_MODE_WINCOMPOSE, UNICODE_MODE_MACOS
