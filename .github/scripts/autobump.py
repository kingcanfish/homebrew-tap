#!/usr/bin/env python3
"""Bump every cask/formula in this tap to its GitHub repo's latest release.

No per-package config: the source repo is read from the first
`https://github.com/<owner>/<repo>/releases/download/` URL in each file, and
each `sha256` is re-mapped by asset name. The old sha is looked up among the
current version's release assets (GitHub reports a `digest` per asset), the
asset name gets the new version swapped in, and that asset's digest in the
latest release becomes the new sha. Multi-arch / multi-variant files work
the same way as single-asset ones.

A file is left untouched (with a warning) when any sha cannot be mapped, so a
release with renamed assets never produces a half-updated cask.
"""

from __future__ import annotations

import hashlib
import json
import os
import re
import subprocess
import sys
import urllib.error
import urllib.request
from pathlib import Path

API = "https://api.github.com"
TOKEN = os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN")
DRY_RUN = "--dry-run" in sys.argv

VERSION_RE = re.compile(r'^(\s*version\s+")([^"]+)(")', re.MULTILINE)
REPO_RE = re.compile(r"https://github\.com/([\w.-]+)/([\w.-]+)/releases/download/")
SHA_RE = re.compile(r'(?<![0-9a-f])[0-9a-f]{64}(?![0-9a-f])')
URL_LINE_RE = re.compile(r'^\s*url\s+".*"', re.MULTILINE)


def api(path: str):
    req = urllib.request.Request(API + path, headers={
        "Accept": "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
        "User-Agent": "homebrew-tap-autobump",
        **({"Authorization": f"Bearer {TOKEN}"} if TOKEN else {}),
    })
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            return json.load(resp)
    except urllib.error.HTTPError as err:
        if err.code == 404:
            return None
        raise


def release_for_version(owner: str, repo: str, version: str):
    for tag in (f"v{version}", version):
        release = api(f"/repos/{owner}/{repo}/releases/tags/{tag}")
        if release:
            return release
    return None


def version_key(version: str):
    return tuple(int(part) if part.isdigit() else part for part in re.split(r"[.\-+]", version))


def asset_sha(asset: dict) -> str:
    digest = asset.get("digest") or ""
    if digest.startswith("sha256:"):
        return digest.split(":", 1)[1]
    # Assets uploaded before GitHub started recording digests: hash the download.
    sha = hashlib.sha256()
    with urllib.request.urlopen(asset["browser_download_url"], timeout=300) as resp:
        for chunk in iter(lambda: resp.read(1 << 20), b""):
            sha.update(chunk)
    return sha.hexdigest()


def bump(path: Path) -> str | None:
    text = path.read_text()
    version_match = VERSION_RE.search(text)
    repo_match = REPO_RE.search(text)
    if not version_match or not repo_match:
        print(f"skip {path.name}: no `version` line or GitHub release URL")
        return None

    current = version_match.group(2)
    owner, repo = repo_match.groups()
    latest = api(f"/repos/{owner}/{repo}/releases/latest")
    if not latest:
        print(f"skip {path.name}: {owner}/{repo} has no published release")
        return None

    new = latest["tag_name"].removeprefix("v")
    if new == current or version_key(new) <= version_key(current):
        print(f"ok   {path.name}: {current} is current")
        return None

    old_release = release_for_version(owner, repo, current)
    if not old_release:
        print(f"WARN {path.name}: release for {current} not found; cannot map checksums", file=sys.stderr)
        return None

    old_name_by_sha = {asset_sha(a): a["name"] for a in old_release["assets"]}
    new_assets = {a["name"]: a for a in latest["assets"]}

    replacements = {}
    for old_sha in set(SHA_RE.findall(text)):
        old_name = old_name_by_sha.get(old_sha)
        if not old_name:
            print(f"WARN {path.name}: sha {old_sha[:12]}… matches no asset of {current}", file=sys.stderr)
            return None
        new_name = old_name.replace(current, new)
        asset = new_assets.get(new_name)
        if not asset:
            print(f"WARN {path.name}: {new_name} missing from release {latest['tag_name']}", file=sys.stderr)
            return None
        replacements[old_sha] = asset_sha(asset)

    text = VERSION_RE.sub(lambda m: m.group(1) + new + m.group(3), text, count=1)
    text = URL_LINE_RE.sub(lambda m: m.group(0).replace(current, new), text)
    text = SHA_RE.sub(lambda m: replacements.get(m.group(0), m.group(0)), text)

    print(f"bump {path.name}: {current} -> {new}")
    if not DRY_RUN:
        path.write_text(text)
    return new


def main() -> int:
    root = Path(__file__).resolve().parents[2]
    files = sorted([*root.glob("Casks/*.rb"), *root.glob("Formula/*.rb")])
    for path in files:
        try:
            new = bump(path)
        except Exception as err:  # one broken package must not block the rest
            print(f"WARN {path.name}: {err}", file=sys.stderr)
            continue
        if new and not DRY_RUN:
            subprocess.run(["git", "add", str(path)], cwd=root, check=True)
            subprocess.run(
                ["git", "commit", "-q", "-m", f"chore: update {path.stem} v{new}"],
                cwd=root, check=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
