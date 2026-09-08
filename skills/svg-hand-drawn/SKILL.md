---
name: svg-hand-drawn-preview
description: Generate a hand-drawn SVG animation package from a local SVG file or SVG URL. Use when the user wants an SVG drawing demo with path-plus-fill animation, or wants the default deliverables to be a standalone preview.html plus a reusable player.js.
---

# SVG Hand-Drawn Preview

Use this skill when the task is to turn an SVG into a hand-drawn animation deliverable.

Default operating mode:
- The agent should generate the output files directly for the user.
- Do not require the user to run Python, Node, or any local build step unless they explicitly ask for a self-serve generator.

Default output:
- A standalone `preview.html` file that can be opened directly in the browser
- A reusable `player.js` file for embedding into another web page

Optional side outputs:
- `animated.svg`
- `animation-plan.json`
- an embed demo page when the user wants component-style integration

Keep this skill independent from any project-specific demo page unless the user explicitly asks to integrate into an existing file.

## What To Produce

By default, produce:
- a self-contained `preview.html`
- a reusable `player.js`

The default result should:
- load a target SVG file or inline SVG markup
- animates path drawing first
- animates fill afterward
- expose a compact control surface when useful: play, speed, progress
- preserves source colors as closely as possible
- reuse the same playback core across both outputs

Only produce side artifacts when they help:
- `animated.svg` for reuse in other apps
- `animation-plan.json` when the user wants structured animation metadata
- an embed demo page when the user wants to show integration inside a normal web page

## Inputs

Accept either:
- a local SVG file path
- an SVG URL

Optional inputs:
- preferred animation mode
- desired output file name
- whether to include playback controls
- whether to emit side artifacts

If the user does not specify these, use:
- output: `preview.html` plus `player.js`
- include controls: yes
- default animation: path draw plus fill reveal

## Workflow

1. Inspect the SVG source first.
- Check whether shapes are stroke-based, fill-only, or mixed.
- Check whether colors live in attributes or inline `style`.
- Check whether there are unsupported constructs such as `foreignObject`, raster images, or masks that cannot be reproduced faithfully.

2. Normalize for animation.
- Mark drawable path-like elements.
- Separate path timing from fill timing.
- For fill-only shapes, create a fill layer plus a temporary stroke layer if needed.
- Preserve original colors and opacity.

3. Build the preview page.
- Prefer a single-file HTML result.
- Keep CSS and JS inside the HTML unless the user explicitly wants multiple files.
- Ensure the page opens cleanly without requiring a local server when possible.
- Emit a sibling `player.js` in the same output directory by default.

4. When the user asks about webpage embedding.
- Prefer a small `player.js` player plus a host-page demo over an iframe-only answer.
- Keep the embed API simple: target selector or element plus SVG markup and playback options.

5. Validate the result.
- Check that the page still renders the complete static SVG before playback.
- Check that playback starts from zero.
- Check that path and fill both appear in the expected order.
- Check that imported fill-only SVGs do not lose their colors.

## Output Rules

- Default to `preview.html` and `player.js` in the current working directory unless the user asks for another location.
- If you create `animated.svg` or `animation-plan.json`, place them next to `preview.html`.
- Keep output names predictable and easy to move into another repository.

## Animation Defaults

Use these defaults unless the SVG or user request suggests otherwise:
- Path animation: smooth hand-draw
- Fill animation: soft reveal after path completion
- Speed: `1x`
- Controls: enabled
- Background: neutral, minimal, not tied to any brand

For fill-heavy illustration SVGs:
- do not guess a thick temporary stroke
- prefer conservative stroke width estimation
- preserve original fill colors exactly

## When To Read Additional References

- Read [references/output-contract.md](references/output-contract.md) when deciding which deliverables to emit.
- Read [references/html-preview-guidelines.md](references/html-preview-guidelines.md) when shaping the standalone preview page.
- Read [assets/preview-template.html](assets/preview-template.html) when you want a neutral starting structure for `preview.html`.
- Read [assets/player.js](assets/player.js) when generating or aligning the reusable player output.

## Constraints

- Do not assume the input SVG already uses animation-friendly structure.
- Do not hard-couple the skill to one existing project file.
- Do not silently drop fill behavior for path animation modes unless the user explicitly asks for stroke-only output.
- Do not change source colors unless the selected animation mode intentionally overrides them.

## Completion Checklist

Before finishing, verify:
- the output HTML opens as a standalone preview
- `player.js` is emitted next to the preview output
- the SVG is visible before playback starts
- path drawing is visible during playback
- fill appears after path completion
- colors remain close to the source SVG
- any optional side outputs remain consistent with the preview behavior
