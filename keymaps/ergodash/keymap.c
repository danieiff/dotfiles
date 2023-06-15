#include QMK_KEYBOARD_H
#include "user_unicode_map.c"

// enum tap_dances {
//     TD_,
// };
// tap_dance_action_t tap_dance_actions[] = {
//     [TD_] = ACTION_TAP_DANCE_DOUBLE(),
// };


enum custom_keycodes {
    EISU = SAFE_RANGE,
};
#define MPLY_VOLU LT(0, KC_VOLU)
#define MUTE_VOLD LT(0, KC_VOLD)
#define PSCR_DEL LT(0, KC_DEL)
#define SFT_ENT LT(0, KC_ENT)
#define LT_RAISE LT(0, RAISE) // or 'TT(RAISE)', 'OSL(RAISE)'

enum layers {
    QWERTY,
    LOWER,
    RAISE,
};
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [QWERTY] = LAYOUT(
//┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐                          ┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐
    _______,    KC_1,    KC_2,    KC_3,    KC_4,    KC_5, _______,                            _______,    KC_6,    KC_7,    KC_8,    KC_9,    KC_0, _______,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
    _______,    KC_Q,    KC_W,    KC_E,    KC_R,    KC_T, _______,                            _______,    KC_Y,    KC_U,    KC_I,    KC_O,    KC_P, KC_BSLS,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
     KC_TAB,    KC_A,    KC_S,    KC_D,    KC_F,    KC_G, KC_RBRC,                           PSCR_DEL,    KC_H,    KC_J,    KC_K,    KC_L, KC_SCLN, KC_QUOT,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
   LT_RAISE,    KC_Z,    KC_X,    KC_C,    KC_V,    KC_B, ALT_T(EISU),                        KC_MINS,    KC_N,    KC_M, KC_COMM,  KC_DOT, KC_SLSH,  KC_GRV,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┐        ┌────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┤
 OSL(LOWER), _______, MUTE_VOLD, MPLY_VOLU, GUI_T(KC_ESC), KC_LBRC, CTL_T(KC_SPC),    SFT_ENT, KC_BSPC,  KC_EQL,       KC_LEFT, KC_DOWN,   KC_UP, KC_RGHT
//└────────┴────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┴────────┘
  ),
  [LOWER] = LAYOUT(
//┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐                          ┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐
//│        │        │        │        │        │        │        │                          │        │        │        │        │        │        │        │
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
//│        │        │        │        │        │        │        │                          │        │        │        │        │        │        │        │
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
//│        │        │        │        │        │        │        │                          │        │        │        │        │        │        │        │
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
//│        │        │        │        │        │        │        │                          │        │        │        │        │        │        │        │
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┐        ┌────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┤
//│        │        │        │        │        │        │        │        │        │        │        │        │        │        │        │        │        │
//└────────┴────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┴────────┘

//┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐                          ┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐

  // L
  XP(BUG,AMBULANCE),XP(ADHESIVE_BANDAGE,RECYCLE),XP(PENCIL2,LOCK),XP(FIRE,TRUCK),XP(POOP,WASTEBASKET),XP(COFFIN,ALIEN),XP(SPARKLES,BOOM),
  // R
  XP(NECKTIE,MONEY_WITH_WINGS),XP(CARD_FILE_BOX,PASSPORT_CONTROL),XP(SPEECH_BALLOON,CLOSED_LOCK_WITH_KEY),XP(LABEL,SAFETY_VEST),XP(ZAP,THREAD),XP(HEAVY_PLUS_SIGN,HEAVY_MINUS_SIGN),XP(BRICKS,TRIANGULAR_FLAG_ON_POST),

//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤

  // L
  XP(LIPSTICK,ANIMATION),XP(IPHONE,MAG),XP(CHILDREN_CROSSING,WHEELCHAIR),XP(CHART_WITH_UPWARDS_TREND,GLOBE_WITH_MERIDIANS),XP(SEE_NO_EVIL,TADA),XP(ROCKET,BOOKMARK),XP(PACKAGE,BENTO),
  // R
  XP(MEMO,BULB),XP(LOUD_SOUND,MUTE),XP(ROTATING_LIGHT,ART),XP(WHITE_CHECK_MARK,TEST_TUBE),XP(CLOWN_FACE,CAMERA_FLASH),XP(CONSTRUCTION_WORKER,GREEN_HEART),XP(WRENCH,HAMMER),

//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
  XP(ALEMBIC,CONSTRUCTION),XP(QUESTION,CROSS), XP(OK,GOOD), XP(GRIN,SMILE),
  XP(ROFL,GRIN_SWE), XP(TEAR,CRY_LOUD), XP(SWEAT,APOLOGY),                                    _______, KC_EXLM,   KC_AT, KC_LPRN, _______, _______, _______,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
    _______, _______, _______, _______, _______, _______, _______,                            _______, _______, _______, _______, _______, _______, _______,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┐        ┌────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┤
  XP(REWIND,LEFT),XP(ARROW_DOWN,DOWN),XP(ARROW_UP,UP), XP(TWISTED_RIGHTWARDS_ARROWS,RIGHT),
                                                 _______, _______, _______,          _______, _______, _______,          _______, _______, _______, _______
//└────────┴────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┴────────┘
  ),
  [RAISE] = LAYOUT(
//┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐                          ┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐
//│        │        │        │        │        │        │        │                          │        │        │        │        │        │        │        │
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
//│        │        │        │        │        │        │        │                          │        │        │        │        │        │        │        │
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
//│        │        │        │        │        │        │        │                          │        │        │        │        │        │        │        │
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
//│        │        │        │        │        │        │        │                          │        │        │        │        │        │        │        │
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┐        ┌────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┤
//│        │        │        │        │        │        │        │        │        │        │        │        │        │        │        │        │        │
//└────────┴────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┴────────┘
//┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐                          ┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐
      AS_UP,   KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,  UC_MAC,                            _______,   KC_F6,   KC_F7,   KC_F8,   KC_F9,  KC_F10,  KC_F11,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
    AS_DOWN, KC_BRIU, _______, KC_MS_U, _______, _______,  UC_WIN,                            _______, _______, _______, _______, _______, _______,  KC_F12,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
     AS_RPT, KC_BRID, KC_MS_L, KC_MS_D, KC_MS_R, _______, UC_WINC,                            _______, _______, _______, _______, _______, _______, _______,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
    _______, DM_RSTP, KC_WH_L, KC_WH_D, KC_WH_U, KC_WH_R, _______,                            _______, _______, _______, _______, _______, _______, _______,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┐        ┌────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┤
    DM_REC1, DM_PLY1, DM_REC2, DM_PLY2,          _______, KC_BTN2, KC_BTN1,          _______, _______, _______,          KC_HOME, KC_PGDN, KC_PGUP,  KC_END
//└────────┴────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┴────────┘
  ),
};


bool process_record_user(uint16_t keycode, keyrecord_t *record) {

  #ifdef CONSOLE_ENABLE
    uprintf("KL: kc: 0x%04X, col: %2u, row: %2u, pressed: %u, time: %5u, int: %u, count: %u\n", keycode, record->event.key.col, record->event.key.row, record->event.pressed, record->event.time, record->tap.interrupted, record->tap.count);
  #endif

  bool hold_start = !record->tap.count && record->event.pressed;
  bool hold_end = !record->tap.count && !record->event.pressed;
  bool tap_start = record->tap.count && record->event.pressed;
  // bool tap_end = record->tap.count && !record->event.pressed;
  switch (keycode) {
    case MPLY_VOLU:
      if (hold_start) {
        tap_code(KC_MPLY);
        return false;
      }
      break;
    case MUTE_VOLD:
      if (hold_start) {
        tap_code(KC_MUTE);
        return false;
      }
      break;
    case PSCR_DEL:
      if (hold_start) {
        tap_code(KC_PSCR);
        return false;
      }
      break;
    case SFT_ENT:
      if (hold_start) {
        tap_code16(LSFT(KC_ENT));
        return false;
      }
      break;
    case LT_RAISE:
      if (tap_start) {
        layer_invert(RAISE);
        return false;
      } else if (hold_start){
        layer_on(RAISE);
        return false;
      } else if (hold_end) {
        layer_off(RAISE);
        return false;
      }
      break;
    case ALT_T(EISU):
      if (tap_start) {
        tap_code16(LALT(KC_GRV));
        return false;
      }
      break;
  }

  return true;
}
uint16_t unicodemap_index(uint16_t keycode) {
    if (keycode >= QK_UNICODEMAP_PAIR) {
        // Keycode is a pair: extract index based on Ctrl state
        uint16_t index;

        uint8_t mods = get_mods() | get_weak_mods();
#ifndef NO_ACTION_ONESHOT
        mods |= get_oneshot_mods();
#endif

        bool shift = mods & MOD_MASK_CTRL;
        bool caps  = host_keyboard_led_state().caps_lock;
        if (shift ^ caps) {
            index = QK_UNICODEMAP_PAIR_GET_SHIFTED_INDEX(keycode);
        } else {
            index = QK_UNICODEMAP_PAIR_GET_UNSHIFTED_INDEX(keycode);
        }

        return index;
    } else {
        // Keycode is a regular index
        return QK_UNICODEMAP_GET_INDEX(keycode);
    }
}
