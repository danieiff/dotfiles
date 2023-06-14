import { dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { writeFileSync } from "node:fs";

const misc_unicode_map = {
    UP: "↑",
    DOWN: "↓",
    LEFT: "←",
    RIGHT: "→",

    HOR: "─",
    I: "│",
    LT: "┌",
    LB: "└",
    RT: "┐",
    RB: "┘",
    VERR: "├",
    VERL: "┤",
    HORB: "┬",
    HORT: "┴",
    CRSS: "┼",

    B_HOR: "━",
    B_VER: "┃",
    B_LT: "┏",
    B_LB: "┗",
    B_RT: "┓",
    B_RB: "┛",
    B_VERR: "┣",
    B_VERL: "┨",
    B_HORB: "┳",
    B_HORT: "┻",
    B_CRSS: "╋",

    QUESTION: "❔",
    CIRCLE_GES: "🙆",
    CROSS_GES: "🙅",
    OK: "👌",
    GOOD: "👍",
    GRIN: "😀",
    SMILE: "☺",
    ROFL: "🤣",
    GRIN_SWE: "😓",
    TEAR: "🥲",
    CRY_LOUD: "😭",
    SWEAT: "💦",
    APOLOGY: "🙇",
    X: "❌",
};

const miscUnicodeData = Object.entries(misc_unicode_map).map(
    ([name, emoji]) => ({
        name,
        code: "0x" + emoji.codePointAt(0).toString(16),
        emoji,
    })
);

const gitmoji_url = "https://gitmoji.dev/api/gitmojis";

const res = await fetch(gitmoji_url);
const { gitmojis } = await res.json();

// 💡 QMK Limitation: Cannot enable more than one Unicode Input methods at the same time.
// grapheme ('🧑‍💻' (technologist)) is not available here.
// const graphemes = [];
const gitmojiUnicodeData = gitmojis.reduce(
    (prev, { emoji, name, entity, description }) => {
        const units = [...emoji].map(
            (emojiUnit) => "0x" + emojiUnit.codePointAt(0).toString(16)
        );

        // const unitCount = entity.split(";").length - 1;
        // if (unitCount > 1) {
        //     graphemes.push({
        //         name,
        //         emoji,
        //         codes: units,
        //         description,
        //     });
        //     return prev;
        // }
        return [
            ...prev,
            {
                emoji,
                code: units[0],
                name: name.replaceAll("-", "_").toUpperCase(),
                description,
            },
        ];
    },
    []
);

const userUnicodeData = [...gitmojiUnicodeData, ...miscUnicodeData];

const indent = "    ";
const src = `enum unicode_names {
${userUnicodeData.map(({ name }) => indent + name).join(",\n")}
};

const uint32_t unicode_map[] PROGMEM = {
${userUnicodeData
    .map(
        ({ name, code, emoji, description = "" }) =>
            indent + `[${name}] = ${code}, // ${emoji} ${description}`
    )
    .join("\n")}
};
`;
// const ucis_symbol_t ucis_symbol_table[] = UCIS_TABLE(
// ${graphemes
//     .map(
//         ({ name, codes, emoji, description = "" }) =>
//             indent +
//             `UCIS_SYM("${name}", ${codes.join(
//                 ", "
//             )}) // ${emoji} ${description}`
//     )
//     .join(",\n")}
// );`;

const file = dirname(fileURLToPath(import.meta.url)) + "/user_unicode_map.c";

writeFileSync(file, src);
