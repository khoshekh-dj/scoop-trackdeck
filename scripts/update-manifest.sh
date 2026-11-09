#!/bin/bash
# update-manifest.sh [version]: writes bucket/trackdeck.json for a TrackDeck
# release (the latest one if no version is given), with the checksum from the
# release's .sha256 file. Needs gh and jq (GH_TOKEN on CI).
set -euo pipefail
repo=khoshekh-dj/trackdeck
version=${1:-$(gh release view -R "${repo}" --json tagName -q .tagName | sed 's/^trackdeck-v//')}
tag=trackdeck-v${version}
zip=TrackDeck-${version}-Windows-x64.zip
hash=$(gh release download "${tag}" -R "${repo}" -p "${zip}.sha256" -O - | awk '{print tolower($1)}')
[[ ${hash} =~ ^[0-9a-f]{64}$ ]] || { echo "bad checksum for ${zip}: '${hash}'" >&2; exit 1; }
cd "$(dirname "$0")/.."
jq -n --arg version "${version}" --arg hash "${hash}" \
      --arg url "https://github.com/${repo}/releases/download/${tag}/${zip}" '{
    version: $version,
    description: "A music player for DJs, with an RGB waveform, a live spectrum visualiser and BPM detection.",
    homepage: "https://khoshekh-dj.github.io/trackdeck/",
    license: "GPL-3.0-only",
    architecture: { "64bit": { url: $url, hash: $hash } },
    extract_dir: "TrackDeck",
    post_install: "New-Item \"$dir\\appdata\" -ItemType File -Force | Out-Null",
    shortcuts: [["TrackDeck.exe", "TrackDeck"]],
    checkver: {
        url: "https://api.github.com/repos/khoshekh-dj/trackdeck/releases/latest",
        jsonpath: "$.tag_name",
        regex: "trackdeck-v([\\d.]+)"
    },
    autoupdate: {
        architecture: { "64bit": {
            url: "https://github.com/khoshekh-dj/trackdeck/releases/download/trackdeck-v$version/TrackDeck-$version-Windows-x64.zip",
            hash: { url: "$url.sha256" }
        } }
    }
}' > bucket/trackdeck.json
echo "bucket/trackdeck.json: ${version}"
