enum unicode_names {
    ART,
    ZAP,
    FIRE,
    BUG,
    AMBULANCE,
    SPARKLES,
    MEMO,
    ROCKET,
    LIPSTICK,
    TADA,
    WHITE_CHECK_MARK,
    LOCK,
    CLOSED_LOCK_WITH_KEY,
    BOOKMARK,
    ROTATING_LIGHT,
    CONSTRUCTION,
    GREEN_HEART,
    ARROW_DOWN,
    ARROW_UP,
    PUSHPIN,
    CONSTRUCTION_WORKER,
    CHART_WITH_UPWARDS_TREND,
    RECYCLE,
    HEAVY_PLUS_SIGN,
    HEAVY_MINUS_SIGN,
    WRENCH,
    HAMMER,
    GLOBE_WITH_MERIDIANS,
    PENCIL2,
    POOP,
    REWIND,
    TWISTED_RIGHTWARDS_ARROWS,
    PACKAGE,
    ALIEN,
    TRUCK,
    PAGE_FACING_UP,
    BOOM,
    BENTO,
    WHEELCHAIR,
    BULB,
    BEERS,
    SPEECH_BALLOON,
    CARD_FILE_BOX,
    LOUD_SOUND,
    MUTE,
    BUSTS_IN_SILHOUETTE,
    CHILDREN_CROSSING,
    BUILDING_CONSTRUCTION,
    IPHONE,
    CLOWN_FACE,
    EGG,
    SEE_NO_EVIL,
    CAMERA_FLASH,
    ALEMBIC,
    MAG,
    LABEL,
    SEEDLING,
    TRIANGULAR_FLAG_ON_POST,
    GOAL_NET,
    ANIMATION,
    WASTEBASKET,
    PASSPORT_CONTROL,
    ADHESIVE_BANDAGE,
    MONOCLE_FACE,
    COFFIN,
    TEST_TUBE,
    NECKTIE,
    STETHOSCOPE,
    BRICKS,
    MONEY_WITH_WINGS,
    THREAD,
    SAFETY_VEST,
    UP,
    DOWN,
    LEFT,
    RIGHT,
    HOR,
    VER,
    LT,
    LB,
    RT,
    RB,
    VERR,
    VERL,
    HORB,
    HORT,
    CRSS,
    B_HOR,
    B_VER,
    B_LT,
    B_LB,
    B_RT,
    B_RB,
    B_VERR,
    B_VERL,
    B_HORB,
    B_HORT,
    B_CRSS,
    QUESTION,
    CIRCLE_GES,
    CROSS_GES,
    OK,
    GOOD,
    GRIN,
    SMILE,
    ROFL,
    GRIN_SWE,
    TEAR,
    CRY_LOUD,
    SWEAT,
    APOLOGY,
    CROSS
};

const uint32_t unicode_map[] PROGMEM = {
    [ART] = 0x1f3a8, // 🎨 Improve structure / format of the code.
    [ZAP] = 0x26a1, // ⚡️ Improve performance.
    [FIRE] = 0x1f525, // 🔥 Remove code or files.
    [BUG] = 0x1f41b, // 🐛 Fix a bug.
    [AMBULANCE] = 0x1f691, // 🚑️ Critical hotfix.
    [SPARKLES] = 0x2728, // ✨ Introduce new features.
    [MEMO] = 0x1f4dd, // 📝 Add or update documentation.
    [ROCKET] = 0x1f680, // 🚀 Deploy stuff.
    [LIPSTICK] = 0x1f484, // 💄 Add or update the UI and style files.
    [TADA] = 0x1f389, // 🎉 Begin a project.
    [WHITE_CHECK_MARK] = 0x2705, // ✅ Add, update, or pass tests.
    [LOCK] = 0x1f512, // 🔒️ Fix security issues.
    [CLOSED_LOCK_WITH_KEY] = 0x1f510, // 🔐 Add or update secrets.
    [BOOKMARK] = 0x1f516, // 🔖 Release / Version tags.
    [ROTATING_LIGHT] = 0x1f6a8, // 🚨 Fix compiler / linter warnings.
    [CONSTRUCTION] = 0x1f6a7, // 🚧 Work in progress.
    [GREEN_HEART] = 0x1f49a, // 💚 Fix CI Build.
    [ARROW_DOWN] = 0x2b07, // ⬇️ Downgrade dependencies.
    [ARROW_UP] = 0x2b06, // ⬆️ Upgrade dependencies.
    [PUSHPIN] = 0x1f4cc, // 📌 Pin dependencies to specific versions.
    [CONSTRUCTION_WORKER] = 0x1f477, // 👷 Add or update CI build system.
    [CHART_WITH_UPWARDS_TREND] = 0x1f4c8, // 📈 Add or update analytics or track code.
    [RECYCLE] = 0x267b, // ♻️ Refactor code.
    [HEAVY_PLUS_SIGN] = 0x2795, // ➕ Add a dependency.
    [HEAVY_MINUS_SIGN] = 0x2796, // ➖ Remove a dependency.
    [WRENCH] = 0x1f527, // 🔧 Add or update configuration files.
    [HAMMER] = 0x1f528, // 🔨 Add or update development scripts.
    [GLOBE_WITH_MERIDIANS] = 0x1f310, // 🌐 Internationalization and localization.
    [PENCIL2] = 0x270f, // ✏️ Fix typos.
    [POOP] = 0x1f4a9, // 💩 Write bad code that needs to be improved.
    [REWIND] = 0x23ea, // ⏪️ Revert changes.
    [TWISTED_RIGHTWARDS_ARROWS] = 0x1f500, // 🔀 Merge branches.
    [PACKAGE] = 0x1f4e6, // 📦️ Add or update compiled files or packages.
    [ALIEN] = 0x1f47d, // 👽️ Update code due to external API changes.
    [TRUCK] = 0x1f69a, // 🚚 Move or rename resources (e.g.: files, paths, routes).
    [PAGE_FACING_UP] = 0x1f4c4, // 📄 Add or update license.
    [BOOM] = 0x1f4a5, // 💥 Introduce breaking changes.
    [BENTO] = 0x1f371, // 🍱 Add or update assets.
    [WHEELCHAIR] = 0x267f, // ♿️ Improve accessibility.
    [BULB] = 0x1f4a1, // 💡 Add or update comments in source code.
    [BEERS] = 0x1f37b, // 🍻 Write code drunkenly.
    [SPEECH_BALLOON] = 0x1f4ac, // 💬 Add or update text and literals.
    [CARD_FILE_BOX] = 0x1f5c3, // 🗃️ Perform database related changes.
    [LOUD_SOUND] = 0x1f50a, // 🔊 Add or update logs.
    [MUTE] = 0x1f507, // 🔇 Remove logs.
    [BUSTS_IN_SILHOUETTE] = 0x1f465, // 👥 Add or update contributor(s).
    [CHILDREN_CROSSING] = 0x1f6b8, // 🚸 Improve user experience / usability.
    [BUILDING_CONSTRUCTION] = 0x1f3d7, // 🏗️ Make architectural changes.
    [IPHONE] = 0x1f4f1, // 📱 Work on responsive design.
    [CLOWN_FACE] = 0x1f921, // 🤡 Mock things.
    [EGG] = 0x1f95a, // 🥚 Add or update an easter egg.
    [SEE_NO_EVIL] = 0x1f648, // 🙈 Add or update a .gitignore file.
    [CAMERA_FLASH] = 0x1f4f8, // 📸 Add or update snapshots.
    [ALEMBIC] = 0x2697, // ⚗️ Perform experiments.
    [MAG] = 0x1f50d, // 🔍️ Improve SEO.
    [LABEL] = 0x1f3f7, // 🏷️ Add or update types.
    [SEEDLING] = 0x1f331, // 🌱 Add or update seed files.
    [TRIANGULAR_FLAG_ON_POST] = 0x1f6a9, // 🚩 Add, update, or remove feature flags.
    [GOAL_NET] = 0x1f945, // 🥅 Catch errors.
    [ANIMATION] = 0x1f4ab, // 💫 Add or update animations and transitions.
    [WASTEBASKET] = 0x1f5d1, // 🗑️ Deprecate code that needs to be cleaned up.
    [PASSPORT_CONTROL] = 0x1f6c2, // 🛂 Work on code related to authorization, roles and permissions.
    [ADHESIVE_BANDAGE] = 0x1fa79, // 🩹 Simple fix for a non-critical issue.
    [MONOCLE_FACE] = 0x1f9d0, // 🧐 Data exploration/inspection.
    [COFFIN] = 0x26b0, // ⚰️ Remove dead code.
    [TEST_TUBE] = 0x1f9ea, // 🧪 Add a failing test.
    [NECKTIE] = 0x1f454, // 👔 Add or update business logic.
    [STETHOSCOPE] = 0x1fa7a, // 🩺 Add or update healthcheck.
    [BRICKS] = 0x1f9f1, // 🧱 Infrastructure related changes.
    [MONEY_WITH_WINGS] = 0x1f4b8, // 💸 Add sponsorships or money related infrastructure.
    [THREAD] = 0x1f9f5, // 🧵 Add or update code related to multithreading or concurrency.
    [SAFETY_VEST] = 0x1f9ba, // 🦺 Add or update code related to validation.
    [UP] = 0x2191, // ↑
    [DOWN] = 0x2193, // ↓
    [LEFT] = 0x2190, // ←
    [RIGHT] = 0x2192, // →
    [HOR] = 0x2500, // ─
    [VER] = 0x2502, // │
    [LT] = 0x250c, // ┌
    [LB] = 0x2514, // └
    [RT] = 0x2510, // ┐
    [RB] = 0x2518, // ┘
    [VERR] = 0x251c, // ├
    [VERL] = 0x2524, // ┤
    [HORB] = 0x252c, // ┬
    [HORT] = 0x2534, // ┴
    [CRSS] = 0x253c, // ┼
    [B_HOR] = 0x2501, // ━
    [B_VER] = 0x2503, // ┃
    [B_LT] = 0x250f, // ┏
    [B_LB] = 0x2517, // ┗
    [B_RT] = 0x2513, // ┓
    [B_RB] = 0x251b, // ┛
    [B_VERR] = 0x2523, // ┣
    [B_VERL] = 0x2528, // ┨
    [B_HORB] = 0x2533, // ┳
    [B_HORT] = 0x253b, // ┻
    [B_CRSS] = 0x254b, // ╋
    [QUESTION] = 0x2754, // ❔
    [OK] = 0x1f44c, // 👌
    [GOOD] = 0x1f44d, // 👍
    [GRIN] = 0x1f600, // 😀
    [SMILE] = 0x263a, // ☺
    [ROFL] = 0x1f923, // 🤣
    [GRIN_SWE] = 0x1f613, // 😓
    [TEAR] = 0x1f972, // 🥲
    [CRY_LOUD] = 0x1f62d, // 😭
    [SWEAT] = 0x1f4a6, // 💦
    [APOLOGY] = 0x1f647, // 🙇
    [CROSS] = 0x274c, // ❌
};
