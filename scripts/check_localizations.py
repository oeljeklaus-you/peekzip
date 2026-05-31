#!/usr/bin/env python3
from __future__ import annotations

import re
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]
L10N = ROOT / "PeekZip" / "L10n.swift"


REQUIRED_LOCALES = [
    "en",
    "zh-Hans",
    "zh-Hant",
    "hi",
    "es",
    "fr",
    "ar",
    "bn",
    "pt-BR",
    "pt-PT",
    "ru",
    "ur",
    "id",
    "de",
    "ja",
    "ko",
    "tr",
    "vi",
    "th",
    "it",
    "nl",
    "pl",
    "uk",
    "ms",
    "fil",
    "fa",
    "sw",
    "ta",
    "te",
    "mr",
]

FALLBACK_LOCALES = {
    "de",
    "es",
    "fr",
    "pt-BR",
    "pt-PT",
    "ru",
    "tr",
    "it",
    "nl",
    "pl",
    "uk",
    "fa",
    "sw",
    "ta",
    "te",
    "mr",
}


def _unique_matches(pattern: str, text: str) -> list[str]:
    seen: set[str] = set()
    items: list[str] = []
    for match in re.findall(pattern, text):
        if match not in seen:
            seen.add(match)
            items.append(match)
    return items


def _extract_block(text: str, marker: str) -> str:
    start = text.find(marker)
    if start < 0:
        return ""
    return text[start:]


def main() -> int:
    text = L10N.read_text(encoding="utf-8")

    key_matches = _unique_matches(r"case\s+([A-Za-z0-9_]+)", text)

    translations_block = _extract_block(text, 'private static let translations:')
    extra_block = _extract_block(text, 'private static let extraTranslations:')

    base_locales = _unique_matches(r'"([A-Za-z-]+)"\s*:\s*\[', translations_block)
    extra_locales = _unique_matches(r'"([A-Za-z-]+)"\s*:\s*merged\(\[', extra_block)

    supported_locales = sorted(set(base_locales) | set(extra_locales))
    missing_supported = [locale for locale in REQUIRED_LOCALES if locale not in supported_locales]
    missing_base = [locale for locale in REQUIRED_LOCALES if locale not in base_locales and locale not in FALLBACK_LOCALES]
    print(f"keys: {len(key_matches)}")
    print(f"base locales: {', '.join(base_locales)}")
    print(f"extra locales: {', '.join(extra_locales)}")
    print(f"supported locales: {', '.join(supported_locales)}")
    print("required locales:", ", ".join(REQUIRED_LOCALES))

    if missing_supported:
        print("missing supported locales:", ", ".join(missing_supported))
    else:
        print("missing supported locales: none")

    if missing_base:
        print("missing base translations (fallback allowed):", ", ".join(missing_base))
    else:
        print("missing base translations (fallback allowed): none")

    print("supplemental locales:", ", ".join(sorted(FALLBACK_LOCALES)))
    print("check completed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
