# Scoop bucket for TrackDeck

[TrackDeck](https://github.com/khoshekh-dj/trackdeck) is a music player for DJs, with an RGB waveform, a live spectrum visualiser and BPM detection.

```powershell
scoop bucket add trackdeck https://github.com/khoshekh-dj/scoop-trackdeck
scoop install trackdeck/trackdeck
```

Update with `scoop update trackdeck`. TrackDeck appears in the Start menu under *Scoop Apps*.

From TrackDeck 1.3.4, settings and the playlist are kept in `%AppData%\TrackDeck`, so updates keep them.

The manifest is updated automatically when TrackDeck has a new release (`.github/workflows/update.yml`, using the checksum published with each release), and each update is test-installed on Windows.
