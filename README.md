# UniSIR project page

Static project page for *UniSIR: A Unified Representation for Driving-Scene Synthesis* (IEEE IV 2027).
Layout follows the DriveDreamer / Nerfies project-page convention: title, authors, links, teaser,
abstract, method, results (images and videos), BibTeX, footer.

Everything here is plain HTML and CSS with no build step and no external dependencies, so GitHub
Pages can serve the folder as it is.

## Preview locally

```powershell
python -m http.server 8099 -d site
# then open http://127.0.0.1:8099/
```

(Open `site/index.html` directly also works, but videos and relative paths behave better over HTTP.)

## What is where

```
site/
  index.html                 the page; every section is marked with a comment
  static/css/style.css       one stylesheet, no framework; colours are CSS variables at the top
  static/images/             9 stills (teaser, pipeline, long-tail figure, 5 cases, six-view)
  static/videos/             8 clips (6 long-tail scenarios, generated and recorded occupancy)
  publish.ps1                one command to push this folder to a GitHub repo
  .nojekyll                  serve the files as they are, without Jekyll
```

## What to edit

| Want to change | Where |
| --- | --- |
| Title, author block, affiliation | `index.html`, the `hero` header |
| Paper / arXiv / code links | `index.html`, the three `<a class="btn">` elements (currently `#`) |
| Abstract | `index.html`, section `#abstract` — it is the paper's abstract verbatim |
| Method text | `index.html`, section `#method` (three short paragraphs) |
| Captions, order of the results | `index.html`, section `#results`, one `<figure class="card">` per item |
| Numbers in the table | `index.html`, the `<table>` in `#results` (mirrors Table I of the paper) |
| BibTeX | `index.html`, section `#bibtex` |
| Colours, widths, spacing | `static/css/style.css`, variables at the top |

## Replacing the media

The stills and clips are generated from what is already in the paper repository, so nothing is
hand-cropped. This website repository only carries the outputs; the generator lives with the paper
(`bin/build_site_media.py` in the UniSIR paper repository) and is run from there:

```powershell
python bin/build_site_media.py      # in the paper repository, writes into site/static/
```

That script re-encodes the videos to 1280 px wide, writes posters from each grid's first frame, and
resizes the figures. If you would rather drop in your own file, put it in `static/images/` or
`static/videos/` and point the `<img src>` / `<video src>` at it — the CSS only assumes a file name.

## Publish to GitHub Pages

Create an empty repository on GitHub first (no README, no licence), then:

```powershell
cd site
.\publish.ps1 -RepoUrl https://github.com/<user>/<repo>.git
```

The script initialises the repository if needed, commits everything and pushes to `main`. Then, once:

**Settings → Pages → Source: Deploy from a branch → Branch: `main`, folder `/ (root)` → Save.**

The page appears at `https://<user>.github.io/<repo>/` within a minute or two.

If you would rather keep it in a repository you already have, push this folder as `docs/` and point
Pages at `main` / `/docs`.

## Checks

```powershell
python bin/check_site.py            # in the paper repository, against this folder
```

Verifies that every local reference resolves, that the title and abstract on the page are character
for character the paper's, that every image has alt text, and that a local HTTP server returns 200
for all 27 URLs the page requests.
