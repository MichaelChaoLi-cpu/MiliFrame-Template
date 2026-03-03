#!/usr/bin/env python3
"""
PostToolUse hook: auto-run `pip freeze > requirements.txt`
after any pip install / uninstall / upgrade command.
"""

import json
import re
import subprocess
import sys
from pathlib import Path


def main() -> None:
    try:
        data = json.loads(sys.stdin.read())
    except json.JSONDecodeError:
        sys.exit(0)

    if data.get("tool_name") != "Bash":
        sys.exit(0)

    command: str = data.get("tool_input", {}).get("command", "")

    if not re.search(r"\bpip\s+(install|uninstall|upgrade)\b", command):
        sys.exit(0)

    req_path = Path("requirements.txt")

    try:
        result = subprocess.run(
            ["pip", "freeze"],
            capture_output=True,
            text=True,
            check=True,
        )
        req_path.write_text(result.stdout)
        print(f"[hook] requirements.txt auto-updated ({req_path.resolve()})")
    except subprocess.CalledProcessError as e:
        print(f"[hook] pip freeze failed: {e.stderr}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
