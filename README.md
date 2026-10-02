# Resume LaTeX Template

This repository builds an English resume with LaTeX and Docker. It contains dummy content only, so you do not need TeX Live installed locally; a running Docker daemon is enough.

## Build

```sh
./scripts/build.sh
```

This builds the dummy template in `src/sections/`, compiles it with XeLaTeX, and writes `dist/ResumeEN.pdf`. The first build downloads the TeX Live image; later builds use the Docker cache.

The script also verifies that the output is A4 and has two pages. When you intentionally change the resume length, set the expected page count before building:

```sh
EXPECTED_PAGES=1 ./scripts/build.sh
```

## Build a Private Resume

Do not edit `src/sections/` if you want to keep the repository safe to publish. Create your personal copy under `private/`; Git ignores this directory and Docker excludes it from the image build context:

```sh
mkdir -p private
cp -R src/sections private/sections
```

Replace the dummy content in `private/sections/`, then build your personal resume:

```sh
RESUME_CONTENT_DIR=private/sections ./scripts/build.sh
```

The script accepts only `src/sections` or `private/sections` as a content source. The default build always uses the public template.

## Customize the Template

`src/main.tex` orchestrates the document. The dummy template files in `src/sections/` are tracked by Git:

- `header.tex`: contact details and headline
- `summary.tex`, `experience.tex`, `publications.tex`: summary, work history, and publications
- `skills.tex`, `education.tex`, `certificates.tex`, `honors.tex`: remaining sections

Font, spacing, and layout macros live in `src/preamble.tex`. You normally do not need to edit this file when updating content.

Kanit is stored in `assets/fonts/`, so the PDF does not depend on fonts installed on the host machine.

## Reference

`assets/reference/ResumeTemplate.pdf` is a dummy PDF for visual comparison and is safe to commit. Keep personal source files and references under `private/`; never use `git add -f private/`.

`build/` and `dist/` contain generated artifacts and are not committed.
