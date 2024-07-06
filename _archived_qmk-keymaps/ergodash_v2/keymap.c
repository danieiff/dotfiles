#include QMK_KEYBOARD_H

typedef enum {
    _QWERTY,
    _RAISE,
} layer_t;

enum custom_keycodes {
    SFT_CLK = SAFE_RANGE,
    CTL_CLK,
};

#define MPLY_VOLU LT(0, KC_VOLU)
#define MUTE_VOLD LT(0, KC_VOLD)
#define PSCR_CCLK LT(0, CTL_CLK)
#define RCLK_SCLK LT(0, SFT_CLK)

#define ACTION_TAP_DANCE_CUSTOM(user_user_data) \
    { .fn = {NULL, td_finished, td_reset}, .user_data = (td_user_data_t *)user_user_data }

typedef enum {
    TD_NONE,
    TD_UNKNOWN,
    TD_SINGLE_TAP,
    TD_SINGLE_HOLD,
    TD_DOUBLE_TAP,
    TD_DOUBLE_HOLD,
    TD_DOUBLE_SINGLE_TAP, // Send two single taps
    td_state_nums
} td_state_t;

typedef struct {
    enum {
        KEYCODE8,
        KEYCODE8_HOLD,
        KEYCODE8_TWICE,
        KEYCODE16,
        LAYER_HOLD,
        LAYER_TOGGLE,
        LAYER_ONESHOT
    } type;
    union {
        uint8_t keycode8;
        uint16_t keycode16;
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

void td_finished(tap_dance_state_t *state, void *user_data);
void td_reset(tap_dance_state_t *state, void *user_data);

enum tap_dances {
    TD_LAYER,
    TD_EISU_GUI,
    TD_PG,
    // TD_BRC
};

tap_dance_action_t tap_dance_actions[] = {
    [TD_LAYER] = ACTION_TAP_DANCE_CUSTOM( &((td_user_data_t) {
        .actions = {
            [TD_SINGLE_HOLD] = { LAYER_HOLD, .layer = _RAISE },
        },
        .options = TD_PERMISSIVE_HOLD,
    })),
    [TD_EISU_GUI] = ACTION_TAP_DANCE_CUSTOM( &((td_user_data_t) {
        .actions = {
            [TD_SINGLE_TAP] = { KEYCODE16, .keycode16 = A(KC_GRV) },
            [TD_SINGLE_HOLD] = { KEYCODE8_HOLD, .keycode8 = KC_LGUI },
        },
        .options = TD_PERMISSIVE_HOLD,
    })),
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [_QWERTY] = LAYOUT_split_4x6_5(
//┌────────┬────────┬────────┬────────┬────────┬────────┐        ┌────────┬────────┬────────┬────────┬────────┬────────┐
    _______,    KC_1,    KC_2,    KC_3,    KC_4,    KC_5,             KC_6,    KC_7,    KC_8,    KC_9,    KC_0,  KC_GRV,
//├────────┼────────┼────────┼────────┼────────┼────────┤        ├────────┼────────┼────────┼────────┼────────┼────────┤
    _______,    KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,             KC_Y,    KC_U,    KC_I,    KC_O,    KC_P, KC_BSLS,
//├────────┼────────┼────────┼────────┼────────┼────────┤        ├────────┼────────┼────────┼────────┼────────┼────────┤
     KC_TAB,    KC_A,    KC_S,    KC_D,    KC_F,    KC_G,             KC_H,    KC_J,    KC_K,    KC_L, KC_SCLN, KC_QUOT,
//├────────┼────────┼────────┼────────┼────────┼────────┤        ├────────┼────────┼────────┼────────┼────────┼────────┤
TD(TD_LAYER),   KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,             KC_N,    KC_M, KC_COMM,  KC_DOT, KC_SLSH, KC_RBRC,
//└────────┴────────┴────────┼────────┼────────┼────────┤        ├────────┼────────┼────────┼────────┴────────┴────────┘
             ALT_T(KC_ESC),CTL_T(KC_SPC),TD(TD_EISU_GUI),          KC_LBRC,  KC_ENT, KC_BSPC,
//                           └────────┼────────┼────────┤        ├────────┼────────┼────────┘
                                       KC_LSFT,  _______,          KC_MINS,  KC_EQL
//                                    └────────┴────────┘        └────────┴────────┘
  ),
  [_RAISE] = LAYOUT_split_4x6_5(
//┌────────┬────────┬────────┬────────┬────────┬────────┐        ┌────────┬────────┬────────┬────────┬────────┬────────┐
    _______, _______, _______, _______, _______, _______,            KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   KC_F6,
//├────────┼────────┼────────┼────────┼────────┼────────┤        ├────────┼────────┼────────┼────────┼────────┼────────┤
    _______, KC_BRIU, KC_WH_L, KC_MS_U, KC_WH_R, KC_WH_U,            KC_F7,   KC_F8,   KC_F9,  KC_F10,  KC_F11,  KC_F12,
//├────────┼────────┼────────┼────────┼────────┼────────┤        ├────────┼────────┼────────┼────────┼────────┼────────┤
    _______, KC_BRID, KC_MS_L, KC_MS_D, KC_MS_R, KC_WH_D,          KC_LEFT, KC_DOWN,   KC_UP, KC_RGHT, DT_PRNT,   DT_UP,
//├────────┼────────┼────────┼────────┼────────┼────────┤        ├────────┼────────┼────────┼────────┼────────┼────────┤
    _______, DM_REC1, DM_REC2, DM_RSTP, DM_PLY1, DM_PLY2,          KC_HOME, KC_PGDN, KC_PGUP,  KC_END, _______, DT_DOWN,
//└────────┴────────┴────────┼────────┼────────┼────────┤        ├────────┼────────┼────────┴────────┴────────┴────────┘
                             KC_BTN1,PSCR_CCLK,MPLY_VOLU,          _______, _______, KC_DEL,
//                           └────────┼────────┼────────┤        ├────────┴────────┴────────┘
                                     RCLK_SCLK,MUTE_VOLD,          _______, _______ 
//                                    └────────┴────────┘        └────────┴────────┘
  ),
};

uint16_t get_tapping_term(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case TD(TD_PG):
            return TAPPING_TERM + 150;
        case TD(TD_LAYER):
            return TAPPING_TERM + 100;
        case TD(TD_EISU_GUI):
            return TAPPING_TERM + 100;
        // case TD(TD_BRC):
        //     return TAPPING_TERM + 100;
        case CTL_T(KC_SPC):
            return TAPPING_TERM + 50;
        case KC_BSPC:
            return TAPPING_TERM + 50;
        default:
            return TAPPING_TERM;
    }
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {

# ifdef CONSOLE_ENABLE
    uprintf("kl: kc: 0x%04x, col: %2u, row: %2u, pressed: %u, time: %5u, int: %u, count: %u\n", keycode, record->event.key.col, record->event.key.row, record->event.pressed, record->event.time, record->tap.interrupted, record->tap.count);
# endif

    bool hold_start = !record->tap.count && record->event.pressed;
    bool hold_end = !record->tap.count && !record->event.pressed;
    bool tap_start = record->tap.count && record->event.pressed;
    // bool tap_end = record->tap.count && !record->event.pressed;
    switch (keycode) {
        case PSCR_CCLK:
            if (tap_start) {
                register_mods(MOD_BIT(KC_LCTL));
                tap_code_delay(KC_BTN1, 5);
                unregister_mods(MOD_BIT(KC_LCTL));
                return false;
            } else if (hold_start) {
                tap_code(KC_PSCR);
                return false;
            }
            break;
        case RCLK_SCLK:
            if (tap_start) {
                register_mods(MOD_BIT(KC_LSFT));
                wait_ms(5);
                tap_code(KC_BTN1);
                unregister_mods(MOD_BIT(KC_LSFT));
                return false;
            } else if (hold_start) {
                register_code(KC_BTN2);
                return false;
            } else if (hold_end) {
                unregister_code(KC_BTN2);
                return false;
            }
            break;
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
    }

    return true;
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

# ifdef CONSOLE_ENABLE
    uprintf("finished count: %u, interrupted: %u, pressed: %u, state: %u, keytype: %u\n", state->count, state->interrupted, state->pressed, user_data->state, td_keycode.type );
# endif

    switch(td_keycode.type) {
        case KEYCODE8: tap_code(td_keycode.keycode8); break;
        case KEYCODE8_HOLD: register_code(td_keycode.keycode8); break;
        case KEYCODE8_TWICE: tap_code(td_keycode.keycode8); register_code(td_keycode.keycode8); break;
        case KEYCODE16: tap_code16(td_keycode.keycode16); break;
        case LAYER_HOLD: layer_on(td_keycode.layer); break;
        case LAYER_TOGGLE: layer_invert(td_keycode.layer); break;
        case LAYER_ONESHOT: set_oneshot_layer(td_keycode.layer, ONESHOT_START); break;
        default: break;
    }
}

void td_reset(tap_dance_state_t *state, void *_user_data) {

    td_user_data_t *user_data = (td_user_data_t *)_user_data;
    td_keycode_t td_keycode = user_data->actions[user_data->state];

# ifdef CONSOLE_ENABLE
    uprintf("reset count: %u,interrupted: %u, pressed: %u, state: %u, keytype: %u\n", state->count, state->interrupted, state->pressed, user_data->state, td_keycode.type );
# endif

    switch(td_keycode.type) {
        case KEYCODE8: break;
        case KEYCODE8_HOLD: unregister_code(td_keycode.keycode8); break;
        case KEYCODE8_TWICE: unregister_code(td_keycode.keycode8); break;
        case KEYCODE16: break;
        case LAYER_HOLD: layer_off(td_keycode.layer); break;
        case LAYER_TOGGLE: break;
        case LAYER_ONESHOT: clear_oneshot_layer_state(ONESHOT_PRESSED); break;
        default: break;
    }

    user_data->state = TD_NONE;
}
