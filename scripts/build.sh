#!/usr/bin/env sh

set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$project_dir"

content_dir=${RESUME_CONTENT_DIR:-src/sections}
case "$content_dir" in
  src/sections|private/sections) ;;
  *)
    printf '%s\n' 'RESUME_CONTENT_DIR must be src/sections or private/sections.' >&2
    exit 1
    ;;
esac

if [ ! -d "$content_dir" ]; then
  printf '%s\n' "Content directory was not found: $content_dir" >&2
  exit 1
fi

mkdir -p build dist
printf '\\def\\resumeContentDir{%s}\n\\input{src/main.tex}\n' "$content_dir" > build/resume.tex

docker build --tag resume-latex:local --file Dockerfile .
docker run --rm \
  --user root \
  --volume "$project_dir:/work" \
  --workdir /work \
  --env TEXMFVAR=/tmp/texmf-var \
  --env TEXMFCONFIG=/tmp/texmf-config \
  --env TEXMFOUTPUT=/tmp \
  resume-latex:local \
  sh -c 'latexmk -g -xelatex -interaction=nonstopmode -halt-on-error -file-line-error -outdir=build build/resume.tex && chown -R "$1:$2" build' sh "$(id -u)" "$(id -g)"

docker run --rm \
  --user "$(id -u):$(id -g)" \
  --volume "$project_dir:/work:ro" \
  --workdir /work \
  --env EXPECTED_PAGES="${EXPECTED_PAGES:-2}" \
  resume-latex:local \
  scripts/verify-pdf.sh build/resume.pdf

mv build/resume.pdf dist/ResumeEN.pdf

printf '%s\n' 'Created dist/ResumeEN.pdf'
