# Orphan Games: picture effects (spec for every core)

Every Orphan Games core (NES, Game Boy, Master System / Game Gear, Atari 2600, and every core added later) shows its
picture through one shared page, `games/shared/index.html`. That page has a **Picture** button with one switch per
effect. Every effect is off until you turn it on, each one works on its own, and the browser remembers your choice
(`localStorage` key `orphanPicture`).

| Switch | What it does |
|---|---|
| Smooth pixels | Scale2x twice (4x): stair-step edges in pixel art become smooth lines |
| Soft filter | bilinear filtering instead of hard pixel edges |
| Vivid colour | more saturation and a little more contrast |
| Glow | bright parts bleed light, like a lit screen |
| Scanlines | dark gaps between the console's lines, like a CRT |
| RGB mask | red / green / blue phosphor stripes |
| Curved screen | tube curvature with dark corners |
| Frame blend | each frame mixed with the last one: smooths flicker |

Two preset buttons only set switches: **Modern** (smooth pixels, soft filter, vivid colour, glow) and **CRT** (soft
filter, glow, scanlines, RGB mask, curved screen). **Off** turns every switch off.

The effects run in the browser (WebGL). They cost the FPGA and the board nothing, and the ORPHAN Remote (CYD) screen
is not affected. With every switch off the page draws exactly as before (sharp pixels on a 2D canvas). A browser
without WebGL shows the switches greyed out.

## Rules for a new core

A core gets every effect, now and later, if its page code follows these rules:

1. **Decode into `px`, never draw yourself.** In `drawFrame(words, sys)`, call `setScreen(w, h, ar)` with the
   console's picture size in pixels and its display aspect ratio (`ar` = width / height as shown on a TV; leave it
   out for square pixels). Then write one RGBA value per pixel into `px` (little endian: `0xAABBGGRR`, alpha 255),
   row by row from the top line. Do not create your own canvas or call `getContext`.
2. **The palette is the core's job, the look is the page's.** Turn the console's colour numbers into true colour in
   `drawFrame` (a lookup table like `PAL`, `SMSPAL`, `A26PAL`). Effects never change the palette.
3. **One frame, one `present('new')`.** `drawFrame` ends with `present('new')`, which is already there for every
   core. Frame blend and the CRT look depend on getting each frame exactly once.
4. **Keep the page copies identical.** `games/shared/index.html` is copied into every `games/orphan_*` folder
   (the same rule as `main.py`).

## Adding an effect

1. Add a line to `FX` in `index.html`: `['name', 'Label', 'what it does']`. The switch appears by itself.
2. Read it in the shader as `uniform float name;` (1.0 = on) in `FIN` and add its name to the uniform list in
   `GLX.draw`. An effect that needs a pass of its own (like Smooth pixels) gets its own program, run before `FIN`.
3. Keep it off by default, independent of the other switches, and cheap enough for a phone.
4. Add it to the table above.
