# Brand logo

The current mark is `logo.svg`: the supplied `flogo.svg`, recolored to Flutter
blue and the site's near-white, with the Thmanyah Serif Display glyph converted
to paths so it renders identically everywhere. The original supplied file is
kept in `design/source-logo.svg`.

To replace it, drop the new square mark here at the same path and keep
`Site.logoAsset` in `lib/config/site.dart` pointed at it. Keep the artwork
square with a little breathing room inside the canvas; the header renders it at
26–30px.
