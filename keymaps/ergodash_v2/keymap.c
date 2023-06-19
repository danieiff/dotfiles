#include QMK_KEYBOARD_H
#include "user_unicode_map.h"

typedef enum {
    _QWERTY,
    _RAISE,
    _LOWER,
} layer_t;

// enum custom_keycodes {};

#define MPLY_VOLU LT(0, KC_VOLU)
#define MUTE_VOLD LT(0, KC_VOLD)
#define SFT_ENT LT(0, KC_ENT)


#define ACTION_TAP_DANCE_FN_ADVANCED_USER(user_fn_on_each_tap, user_fn_on_dance_finished, user_fn_on_dance_reset, user_user_data) \
    { .fn = {user_fn_on_each_tap, user_fn_on_dance_finished, user_fn_on_dance_reset}, .user_data = (void *)user_user_data, }

typedef enum {
    TD_NONE,
    TD_UNKNOWN,
    TD_SINGLE_TAP,
    TD_SINGLE_HOLD,
    TD_DOUBLE_TAP,
    TD_DOUBLE_HOLD,
    TD_DOUBLE_SINGLE_TAP, // Send two single taps
    // TD_TRIPLE_TAP,
    // TD_TRIPLE_HOLD,
    td_state_nums
} td_state_t;

typedef struct {
    enum {
        KEYCODE8,
        KEYCODE8_HOLD,
        KEYCODE8_TWICE,
        KEYCODE16,
        UNICODE,
        LAYER_HOLD,
        LAYER_TOGGLE,
        LAYER_ONESHOT
    } type;
    union {
        uint8_t keycode8;
        uint16_t keycode16;
        char* unicode;
        layer_t layer;
    };
} td_keycode_t;

typedef struct {
  td_keycode_t actions[td_state_nums];
  td_state_t state;
  enum {
      TD_PERMISSIVE_HOLD = 1 << 0,
  } options;
} td_user_data_t;

// typedef td_keycode_t td_user_data_t[td_state_nums];

td_state_t cur_dance(tap_dance_state_t *state, bool is_permissive_hold);
void td_finished(tap_dance_state_t *state, void *user_data);
void td_reset(tap_dance_state_t *state, void *user_data);

enum tap_dances {
    TD_RAISE,
    TD_LOWER,
    TD_ESC_ALT,
    TD_EISU_GUI,
    TD_PSCR_SIGN,
    TD_EMO_POSI,
    TD_EMO_NEGA,
    TD_ARROW,
    TD_GITMOJI_MISC,
    TD_PGCTL,
    TD_PRN,
    TD_BRC,
    TD_L_CLK,
};

tap_dance_action_t tap_dance_actions[] = {
    [TD_RAISE] = ACTION_TAP_DANCE_FN_ADVANCED_USER( NULL, td_finished, td_reset,
        &((td_user_data_t) {
            .actions = {
                [TD_SINGLE_TAP] = { LAYER_TOGGLE, .layer= _RAISE },
                [TD_SINGLE_HOLD] = { LAYER_HOLD, .layer= _RAISE },
                [TD_DOUBLE_TAP] = { UNICODE, .unicode= " " },
                [TD_DOUBLE_HOLD] = { UNICODE, .unicode= " " }
            },
        })
    ),
    [TD_LOWER] = ACTION_TAP_DANCE_FN_ADVANCED_USER( NULL, td_finished, td_reset,
        &((td_user_data_t) {
            .actions = {
                [TD_SINGLE_TAP] = { LAYER_ONESHOT, .layer= _LOWER },
                [TD_SINGLE_HOLD] = { LAYER_HOLD, .layer= _LOWER },
                [TD_DOUBLE_TAP] = { UNICODE, .unicode= " " },
                [TD_DOUBLE_HOLD] = { UNICODE, .unicode= " " }
            },
        })
    ),
    [TD_ESC_ALT] = ACTION_TAP_DANCE_FN_ADVANCED_USER( NULL, td_finished, td_reset,
        &((td_user_data_t) {
            .actions = {
                [TD_SINGLE_TAP] = { KEYCODE8, .keycode8 = KC_ESC },
                [TD_SINGLE_HOLD] = { KEYCODE8_HOLD, .keycode8 = KC_LALT },
                [TD_DOUBLE_TAP] = { UNICODE, .unicode= " " },
                [TD_DOUBLE_HOLD] = { UNICODE, .unicode= " " }
            },
            .options = TD_PERMISSIVE_HOLD,

        })
    ),
    [TD_EISU_GUI] = ACTION_TAP_DANCE_FN_ADVANCED_USER( NULL, td_finished, td_reset,
        &((td_user_data_t) {
            .actions = {
                [TD_SINGLE_TAP] = { KEYCODE16, .keycode16 = A(KC_GRV) },
                [TD_SINGLE_HOLD] = { KEYCODE8_HOLD, .keycode8 = KC_LGUI },
                [TD_DOUBLE_TAP] = { UNICODE, .unicode= " " },
                [TD_DOUBLE_HOLD] = { UNICODE, .unicode= " " }
            },
            .options = TD_PERMISSIVE_HOLD,
        })
    ),
    [TD_PSCR_SIGN] = ACTION_TAP_DANCE_FN_ADVANCED_USER( NULL, td_finished, td_reset,
        &((td_user_data_t) {
            .actions = {
                [TD_SINGLE_TAP] = { KEYCODE8, .keycode8 = KC_PSCR },
                [TD_SINGLE_HOLD] = { UNICODE, .unicode= "❔" },
                [TD_DOUBLE_TAP] = { UNICODE, .unicode= "👌" },
                [TD_DOUBLE_HOLD] = { UNICODE, .unicode= "❌" }
            },
        })
    ),
    [TD_EMO_POSI] = ACTION_TAP_DANCE_FN_ADVANCED_USER( NULL, td_finished, td_reset,
        &((td_user_data_t) {
            .actions = {
                [TD_SINGLE_TAP] = { UNICODE, .unicode= "👍" },
                [TD_SINGLE_HOLD] = { UNICODE, .unicode= "😀" },
                [TD_DOUBLE_TAP] = { UNICODE, .unicode= "☺" },
                [TD_DOUBLE_HOLD] = { UNICODE, .unicode= "🤣" }
            },
        })
    ),
    [TD_EMO_NEGA] = ACTION_TAP_DANCE_FN_ADVANCED_USER( NULL, td_finished, td_reset,
        &((td_user_data_t) {
            .actions = {
                [TD_SINGLE_TAP] = { UNICODE, .unicode = "🙇" },
                [TD_SINGLE_HOLD] = { UNICODE, .unicode= "😓" },
                [TD_DOUBLE_TAP] = { UNICODE, .unicode= "🥲" },
                [TD_DOUBLE_HOLD] = { UNICODE, .unicode= "😭" },
            },
        })
    ),
    [TD_ARROW] = ACTION_TAP_DANCE_FN_ADVANCED_USER( NULL, td_finished, td_reset,
        &((td_user_data_t) {
            .actions = {
                [TD_SINGLE_TAP] = { UNICODE, .unicode= "→" },
                [TD_SINGLE_HOLD] = { UNICODE, .unicode= "←" },
                [TD_DOUBLE_TAP] = { UNICODE, .unicode= "↑" },
                [TD_DOUBLE_HOLD] = { UNICODE, .unicode= "↓" },
            },
        })
    ),
    [TD_PGCTL] = ACTION_TAP_DANCE_FN_ADVANCED_USER( NULL, td_finished, td_reset,
        &((td_user_data_t) {
            .actions = {
                [TD_SINGLE_TAP] = { KEYCODE8, .keycode8= KC_PGDN },
                [TD_SINGLE_HOLD] = { KEYCODE8, .keycode8= KC_PGUP },
                [TD_DOUBLE_TAP] = { KEYCODE8,  .keycode8= KC_END },
                [TD_DOUBLE_HOLD] = { KEYCODE8, .keycode8= KC_HOME },
                },
        })
    ),
    [TD_BRC] = ACTION_TAP_DANCE_FN_ADVANCED_USER( NULL, td_finished, td_reset,
        &((td_user_data_t) {
            .actions = {
                [TD_SINGLE_TAP] = { KEYCODE8, .keycode8= KC_LBRC },
                [TD_SINGLE_HOLD] = { KEYCODE16, .keycode16 = S(KC_LBRC) },
                [TD_DOUBLE_TAP] = { KEYCODE8, .keycode8= KC_RBRC },
                [TD_DOUBLE_HOLD] = { KEYCODE16, .keycode16 = S(KC_RBRC) },
            },
        })
    ),
    [TD_L_CLK] = ACTION_TAP_DANCE_FN_ADVANCED_USER( NULL, td_finished, td_reset,
        &((td_user_data_t) {
            .actions = {
                [TD_SINGLE_TAP] = { KEYCODE8, .keycode8= KC_BTN1 },
                [TD_SINGLE_HOLD] = { KEYCODE8_HOLD, .keycode8= KC_BTN1 },
                [TD_DOUBLE_TAP] = { KEYCODE16, .keycode16 = S(KC_BTN1) },
                [TD_DOUBLE_HOLD] = { KEYCODE16, .keycode16 = C(KC_BTN1) },
            },
        })
    ),
};


const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [_QWERTY] = LAYOUT(
//┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐                          ┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐
  MPLY_VOLU,    KC_1,    KC_2,    KC_3,    KC_4,    KC_5, TD(TD_EMO_POSI),            TD(TD_EMO_NEGA),    KC_6,    KC_7,    KC_8,    KC_9,    KC_0, TD(TD_PGCTL),
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
  MUTE_VOLD,    KC_Q,    KC_W,    KC_E,    KC_R,    KC_T, KC_RGHT,                              KC_UP,    KC_Y,    KC_U,    KC_I,    KC_O,    KC_P, KC_BSLS,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
     KC_TAB,    KC_A,    KC_S,    KC_D,    KC_F,    KC_G, KC_LEFT,                            KC_DOWN,    KC_H,    KC_J,    KC_K,    KC_L, KC_SCLN, KC_QUOT,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
TD(TD_RAISE),   KC_Z,    KC_X,    KC_C,    KC_V,    KC_B, TD(TD_EISU_GUI),                    KC_MINS,    KC_N,    KC_M, KC_COMM,  KC_DOT, KC_SLSH,  KC_GRV,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┐        ┌────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┤
TD(TD_LOWER),TD(TD_ARROW),_______,_______,TD(TD_BRC), TD(TD_ESC_ALT), CTL_T(KC_SPC),   SFT_ENT, KC_BSPC, KC_EQL, TD(TD_PSCR_SIGN), TD(TD_GITMOJI_MISC), _______, _______
//└────────┴────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┴────────┘
  ),
  [_LOWER] = LAYOUT(
//┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐                          ┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐
//│        │        │        │        │        │        │        │                          │        │        │        │        │        │        │        │
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
//│        │ ✨  💥 │ 🚨  🎨 │ 💡  🔊 │ 📝     │        │        │                          │        │ ✅  🧪 │ 🤡  ⚗  │  🏷 🦺 │        │        │        │
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
//│        │ 🐛  🚑 │ 🩹  ♻  │ 🔥  🚚 │  🗑 👽 │        │        │                          │        │ 👔  💸 │ 🧱  🗃 │ ⚡  🧵 │ 🔒  🛂 │        │        │
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
//│        │ 🚧  👷 │ 🔧  🔨 │ ➕  ➖ │  ⬆  ⬇  │ 🚀  🔖 │ 🔀  ⏪️ │                          │        │ 💄  💫 │ 🚸  ♿ │ 📱  🔍 │ 📈  🌐 │ 💬  🍱 │        │
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┐        ┌────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┤
//│        │        │        │        │        │        │        │        │        │        │        │        │        │        │        │        │        │
//└────────┴────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┴────────┘
//┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐                          ┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐
    _______, _______, _______, _______, _______, _______, _______,                            _______, _______, _______, _______, _______, _______, _______,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
    _______,XP(SPARKLES,BOOM),XP(ROTATING_LIGHT,ART),XP(LOUD_SOUND,BULB),X(MEMO),_______, _______,
    _______,XP(WHITE_CHECK_MARK,TEST_TUBE),XP(CLOWN_FACE,ALEMBIC),XP(LABEL,SAFETY_VEST),_______, _______, _______,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
    _______,XP(BUG,AMBULANCE),XP(ADHESIVE_BANDAGE,RECYCLE),XP(FIRE,TRUCK),XP(WASTEBASKET,ALIEN), _______, _______,
    _______,XP(NECKTIE,MONEY_WITH_WINGS),XP(BRICKS,CARD_FILE_BOX), XP(ZAP,THREAD),XP(CLOSED_LOCK_WITH_KEY,PASSPORT_CONTROL), _______, _______,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
    _______,XP(CONSTRUCTION,CONSTRUCTION_WORKER),XP(WRENCH,HAMMER),XP(HEAVY_PLUS_SIGN,HEAVY_MINUS_SIGN),XP(ARROW_UP,ARROW_DOWN),XP(ROCKET,BOOKMARK),XP(TWISTED_RIGHTWARDS_ARROWS,REWIND),
    _______,XP(LIPSTICK,ANIMATION),XP(CHILDREN_CROSSING,WHEELCHAIR),XP(IPHONE,MAG),XP(CHART_WITH_UPWARDS_TREND,GLOBE_WITH_MERIDIANS),XP(SPEECH_BALLOON,BENTO),_______,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┐        ┌────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┤
    _______, _______, _______, _______,          _______, _______, _______,          _______, _______, _______,          _______, _______, _______, _______
//└────────┴────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┴────────┘
  ),
  [_RAISE] = LAYOUT(
//┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐                          ┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐ UC_WINC,  UC_MAC,
    _______, _______, _______, _______, _______, _______, _______,                             UC_MAC, AS_DOWN,  AS_RPT,   AS_UP, DT_DOWN, DT_PRNT,   DT_UP,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
    _______, KC_BRIU, KC_WH_L, KC_MS_U, KC_WH_R, KC_WH_U, _______,                            UC_WINC,   KC_F6,   KC_F7,   KC_F8,   KC_F9,  KC_F10,  KC_F11,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
    _______, KC_BRID, KC_MS_L, KC_MS_D, KC_MS_R, KC_WH_D, _______,                            _______,    KC_1,    KC_2,    KC_3,    KC_4,    KC_5,  KC_F12,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
    _______,   KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5, C(KC_BTN1),                         _______, _______,    KC_6,    KC_7,    KC_8,    KC_9, DM_RSTP,
//├────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┐        ┌────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┤
    _______, _______, _______, TD(TD_L_CLK),  KC_BTN2, S(KC_BTN1), KC_BTN1,          _______, _______,    KC_0,          DM_REC1, DM_PLY1, DM_REC2, DM_PLY2
//└────────┴────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┴────────┘
  ),
};


bool process_record_user(uint16_t keycode, keyrecord_t *record) {

# ifdef CONSOLE_ENABLE
    uprintf("KL: kc: 0x%04X, col: %2u, row: %2u, pressed: %u, time: %5u, int: %u, count: %u\n", keycode, record->event.key.col, record->event.key.row, record->event.pressed, record->event.time, record->tap.interrupted, record->tap.count);
# endif

  bool hold_start = !record->tap.count && record->event.pressed;
  // bool hold_end = !record->tap.count && !record->event.pressed;
  // bool tap_start = record->tap.count && record->event.pressed;
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
    case SFT_ENT:
      if (hold_start) {
        tap_code16(LSFT(KC_ENT));
        return false;
      }
      break;
    case TD(TD_ESC_ALT): return TAPPING_TERM - 50;
    case TD(TD_EISU_GUI): return TAPPING_TERM - 80;
    case TD(TD_L_CLK): return TAPPING_TERM + 100;
  }

  return true;
}

uint16_t unicodemap_index(uint16_t keycode) {
    if (keycode >= QK_UNICODEMAP_PAIR) {
        // Keycode is a pair: extract index based on Ctrl state
        uint16_t index;
        uint8_t mods = get_mods() | get_weak_mods();

#         ifndef NO_ACTION_ONESHOT
            mods |= get_oneshot_mods();
#         endif

        bool ctrl = mods & MOD_MASK_CTRL;
        if (ctrl) {
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


td_state_t cur_dance(tap_dance_state_t *state, bool is_permissive_hold) {
    switch (state->count) {
        case 1:
            if (is_permissive_hold && state->interrupted) return TD_SINGLE_HOLD;
            // Key has not been interrupted, but the key is still held. Means you want to send a 'HOLD'.
            return ((state->interrupted || !state->pressed) ? TD_SINGLE_TAP : TD_SINGLE_HOLD);
        case 2:
            // interrupted: An another key has been hit under the tapping term.
            // tapping ['f'(single tap dance) 'f'(single tap dance) 'b'(another key)] within the tapping term results "ffb" not the double tap dance.
            return ((state->interrupted) ? TD_DOUBLE_SINGLE_TAP : (state->pressed) ? TD_DOUBLE_HOLD : TD_DOUBLE_TAP);
        default: return TD_UNKNOWN;
    }
}

void td_finished(tap_dance_state_t *state, void *_user_data) {

    td_user_data_t *user_data = (td_user_data_t *)_user_data;
    user_data->state = cur_dance(state, user_data->options & TD_PERMISSIVE_HOLD);
    td_keycode_t td_keycode = user_data->actions[user_data->state];

    uprintf("finished state: %u, keytype: %u\n", user_data->state, td_keycode.type );

    switch(td_keycode.type) {
        case KEYCODE8: tap_code(td_keycode.keycode8); break;
        case KEYCODE8_HOLD: register_code(td_keycode.keycode8); break;
        case KEYCODE8_TWICE: tap_code(td_keycode.keycode8); tap_code(td_keycode.keycode8); break;
        case KEYCODE16: tap_code16(td_keycode.keycode16); break;
        case UNICODE: send_unicode_string(td_keycode.unicode); break;
        case LAYER_HOLD: layer_on(td_keycode.layer); break;
        case LAYER_TOGGLE: layer_invert(td_keycode.layer); break;
        case LAYER_ONESHOT: set_oneshot_layer(td_keycode.layer, ONESHOT_START); break;
        default: break;
    }
}

void td_reset(tap_dance_state_t *state, void *_user_data) {

    td_user_data_t *user_data = (td_user_data_t *)_user_data;
    td_keycode_t td_keycode = user_data->actions[user_data->state];
    uprintf("finished state: %u, keytype: %u\n", user_data->state, td_keycode.type );

    switch(td_keycode.type) {
        case KEYCODE8: break;
        case KEYCODE8_HOLD: unregister_code(td_keycode.keycode8); break;
        case KEYCODE16: break;
        case UNICODE: break;
        case LAYER_HOLD: layer_off(td_keycode.layer); break;
        case LAYER_TOGGLE: break;
        case LAYER_ONESHOT: clear_oneshot_layer_state(ONESHOT_PRESSED); break;
        default: break;
    }

    state = TD_NONE;
}
