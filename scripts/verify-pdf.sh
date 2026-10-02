#!/usr/bin/env sh

set -eu

pdf_path=${1:?Usage: scripts/verify-pdf.sh path/to/resume.pdf}
expected_pages=${EXPECTED_PAGES:-2}

if [ ! -s "$pdf_path" ]; then
  printf '%s\n' "PDF was not created: $pdf_path" >&2
  exit 1
fi

page_count=$(pdfinfo "$pdf_path" | awk '/^Pages:/ { print $2 }')
page_size=$(pdfinfo "$pdf_path" | awk -F: '/^Page size:/ { print $2 }')

if [ "$page_count" != "$expected_pages" ]; then
  printf '%s\n' "Expected $expected_pages pages, found ${page_count:-unknown}." >&2
  exit 1
fi

case "$page_size" in
  *A4*) ;;
  *)
    printf '%s\n' "Expected A4 page size, found:${page_size:- unknown}" >&2
    exit 1
    ;;
esac

printf '%s\n' "Verified $pdf_path: A4, $page_count pages."
