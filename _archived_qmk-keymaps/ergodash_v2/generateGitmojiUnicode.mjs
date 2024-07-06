import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { writeFileSync } from "node:fs";

const gitmoji_url = "https://gitmoji.dev/api/gitmojis";

const res = await fetch(gitmoji_url);
const { gitmojis } = await res.json();

// 💡 QMK Limitation: Cannot enable more than one Unicode Input methods at the same time.
// grapheme ('🧑‍💻' (technologist)) will be processed by 'send_unicode_string()' method.
const gitmojiGraphemes = [];

const gitmojiUnicodeMap = gitmojis.reduce(
  (prev, { emoji, name, entity, description }) => {
    const upperCaseName = name.replaceAll("-", "_").toUpperCase();

    const unitCount = entity.split(";").length - 1;
    if (unitCount > 1) {
      gitmojiGraphemes.push({ name: upperCaseName, emoji });
      return prev;
    }

    const firstUnitCode = "0x" + emoji[0].codePointAt(0).toString(16);

    return [
      ...prev,
      {
        emoji,
        code: firstUnitCode,
        name: upperCaseName,
        description,
      },
    ];
  },
  [],
);

const indent = "    ";
const src = `enum unicode_names {
${gitmojiUnicodeMap.map(({ name }) => indent + name).join(",\n")}
};

const uint32_t unicode_map[] PROGMEM = {
${
  gitmojiUnicodeMap
    .map(
      ({ name, code, emoji, description = "" }) =>
        indent + `[${name}] = ${code}, // ${emoji} ${description}`,
    )
    .join("\n")
}
};

${gitmojiGraphemes.map(({ name, emoji }) => `#define ${name} "${emoji}"\n`)}
`;

const file = resolve(
  dirname(fileURLToPath(import.meta.url)) + "unicode_gitmoji.h",
);

writeFileSync(file, src);
