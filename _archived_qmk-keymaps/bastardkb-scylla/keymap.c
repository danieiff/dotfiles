#include QMK_KEYBOARD_H

typedef enum {
  _QWERTY,
  _RAISE,
} layer_t;

enum custom_keycodes {
  SFT_CLK = SAFE_RANGE,
  CTL_CLK,
};

#define MPLY_VOLU LT(2, KC_VOLU)
#define MUTE_VOLD LT(0, KC_VOLD)
#define PSCR_CCLK LT(0, CTL_CLK)
#define RCLK_SCLK LT(0, SFT_CLK)

#define ACTION_TAP_DANCE_CUSTOM(user_user_data)                                \
  {                                                                            \
    .fn = {NULL, td_finished, td_reset},                                       \
    .user_data = (td_user_data_t *)user_user_data                              \
  }

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
  TD_LAYER
};

tap_dance_action_t tap_dance_actions[] = {
    [TD_LAYER] = ACTION_TAP_DANCE_CUSTOM(&((td_user_data_t){
        .actions =
            {
                [TD_SINGLE_HOLD] = {LAYER_HOLD, .layer = _RAISE},
            },
        .options = TD_PERMISSIVE_HOLD,
    }))
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [_QWERTY] = LAYOUT_split_4x6_5(
        //┌────────┬────────┬────────┬────────┬────────┬────────┐ ┌────────┬────────┬────────┬────────┬────────┬────────┐
       LALT(KC_GRV),    KC_1,    KC_2,    KC_3,    KC_4,    KC_5,      KC_6,    KC_7,    KC_8,    KC_9,    KC_0,  KC_GRV,
        //├────────┼────────┼────────┼────────┼────────┼────────┤ ├────────┼────────┼────────┼────────┼────────┼────────┤
             KC_ESC,   KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,      KC_Y,    KC_U,    KC_I,    KC_O,    KC_P, KC_BSLS,
        //├────────┼────────┼────────┼────────┼────────┼────────┤ ├────────┼────────┼────────┼────────┼────────┼────────┤
             KC_TAB,    KC_A,    KC_S,    KC_D,    KC_F,    KC_G,      KC_H,    KC_J,    KC_K,    KC_L, KC_SCLN, KC_QUOT,
        //├────────┼────────┼────────┼────────┼────────┼────────┤ ├────────┼────────┼────────┼────────┼────────┼────────┤
       TD(TD_LAYER),    KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,      KC_N,    KC_M, KC_COMM,  KC_DOT, KC_SLSH, KC_RBRC,
        //└────────┴────────┴────────┼────────┼────────┼────────┤ ├────────┼────────┼────────┼────────┴────────┴────────┘
                                       KC_LALT, KC_LCTL, KC_LGUI,   KC_MINS,  KC_ENT, KC_BSPC,
        //                           └────────┼────────┼────────┤ ├────────┼────────┼────────┘
                                                KC_LSFT,  KC_SPC,    KC_EQL, KC_LBRC
        //                                    └────────┴────────┘ └────────┴────────┘
        ),
    [_RAISE] = LAYOUT_split_4x6_5(
        //┌────────┬────────┬────────┬────────┬────────┬────────┐ ┌────────┬────────┬────────┬────────┬────────┬────────┐
            DM_RSTP, DM_REC1,KC_BRID,KC_BRIU,MUTE_VOLD,MPLY_VOLU,     KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   KC_F6,
        //├────────┼────────┼────────┼────────┼────────┼────────┤ ├────────┼────────┼────────┼────────┼────────┼────────┤
            _______, DM_PLY1, KC_WH_L, KC_MS_U, KC_WH_R, KC_WH_U,     KC_F7,   KC_F8,   KC_F9,  KC_F10,  KC_F11,  KC_F12,
        //├────────┼────────┼────────┼────────┼────────┼────────┤ ├────────┼────────┼────────┼────────┼────────┼────────┤
            _______, DM_REC2, KC_MS_L, KC_MS_D, KC_MS_R, KC_WH_D,   KC_LEFT, KC_DOWN,   KC_UP, KC_RGHT, _______, _______,
        //├────────┼────────┼────────┼────────┼────────┼────────┤ ├────────┼────────┼────────┼────────┼────────┼────────┤
            _______, DM_PLY2, KC_LEFT, KC_DOWN,   KC_UP, KC_RGHT,   KC_HOME, KC_PGDN, KC_PGUP,  KC_END, _______, _______,
        //└────────┴────────┴────────┼────────┼────────┼────────┤ ├────────┼────────┼────────┴────────┴────────┴────────┘
                                     KC_BTN1, PSCR_CCLK, _______,   _______, _______,  KC_DEL,
        //                           └────────┼────────┼────────┤ ├────────┼────────┤────────┘
                                              RCLK_SCLK, _______,   _______, _______
        //                                    └────────┴────────┘ └────────┴────────┘
        ),
};

uint16_t get_tapping_term(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
  case TD(TD_LAYER):
    return TAPPING_TERM + 100;
  default:
    return TAPPING_TERM;
  }
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {

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
    if (is_permissive_hold && state->interrupted)
      return TD_SINGLE_HOLD;
    // Key has not been interrupted, but the key is still held. Means you want to send a 'HOLD'.
    return ((state->interrupted || !state->pressed) ? TD_SINGLE_TAP
                                                    : TD_SINGLE_HOLD);
  case 2:
    // interrupted: An another key has been hit under the tapping term.
    // tapping ['f'(single tap dance) 'f'(single tap dance) 'b'(another key)]
    // within the tapping term results "ffb" not the double tap dance.
    return ((state->interrupted) ? TD_DOUBLE_SINGLE_TAP
            : (state->pressed)   ? TD_DOUBLE_HOLD
                                 : TD_DOUBLE_TAP);
  default:
    return TD_UNKNOWN;
  }
}

void td_finished(tap_dance_state_t *state, void *_user_data) {

  td_user_data_t *user_data = (td_user_data_t *)_user_data;
  user_data->state = cur_dance(state, user_data->options & TD_PERMISSIVE_HOLD);
  td_keycode_t td_keycode = user_data->actions[user_data->state];

  switch (td_keycode.type) {
  case KEYCODE8:
    tap_code(td_keycode.keycode8);
    break;
  case KEYCODE8_HOLD:
    register_code(td_keycode.keycode8);
    break;
  case KEYCODE8_TWICE:
    tap_code(td_keycode.keycode8);
    register_code(td_keycode.keycode8);
    break;
  case KEYCODE16:
    tap_code16(td_keycode.keycode16);
    break;
  case LAYER_HOLD:
    layer_on(td_keycode.layer);
    break;
  case LAYER_TOGGLE:
    layer_invert(td_keycode.layer);
    break;
  case LAYER_ONESHOT:
    set_oneshot_layer(td_keycode.layer, ONESHOT_START);
    break;
  default:
    break;
  }
}

void td_reset(tap_dance_state_t *state, void *_user_data) {

  td_user_data_t *user_data = (td_user_data_t *)_user_data;
  td_keycode_t td_keycode = user_data->actions[user_data->state];

  switch (td_keycode.type) {
  case KEYCODE8:
    break;
  case KEYCODE8_HOLD:
    unregister_code(td_keycode.keycode8);
    break;
  case KEYCODE8_TWICE:
    unregister_code(td_keycode.keycode8);
    break;
  case KEYCODE16:
    break;
  case LAYER_HOLD:
    layer_off(td_keycode.layer);
    break;
  case LAYER_TOGGLE:
    break;
  case LAYER_ONESHOT:
    clear_oneshot_layer_state(ONESHOT_PRESSED);
    break;
  default:
    break;
  }

  user_data->state = TD_NONE;
}
