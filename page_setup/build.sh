#!/bin/bash

# Make shure $1 is a directory and non-empty
if [[ $# -ne 2 || ! -d $1 ]] ; then
  echo "USAGE: build.sh [dir to install wiki] [url of site]" >&2;
  exit 1;
fi

INSTALL_DIR=$1;
SITE_URL=$2;
SOURCE_DIR=$(dirname "$0");
MARKDOWN_DIR=$SOURCE_DIR/../stories;
PANDOC_ARGS="--pdf-engine=weasyprint";

# Copy Base wiki page
cp $SOURCE_DIR/Home_head.md $INSTALL_DIR/Home.md;

for ARTICLE in $(find $MARKDOWN_DIR -name "*.md")
do
  NAME=$(basename $ARTICLE .md);
  echo "working on $NAME.";
  # Compile pdf
  pandoc $PANDOC_ARGS $ARTICLE -o $INSTALL_DIR/$NAME.pdf;
  # Add link to homepage
  echo "- [$NAME]($SITE_URL/$NAME.pdf)\n" >> $INSTALL_DIR/Home.md;
done

#create Home.html
cat $SOURCE_DIR/Home_foot.md >> $INSTALL_DIR/Home.md;
pandoc $PANDOC_ARGS Home.md -o $INSTALL_DIR/index.html;
# remove Home.md
rm $INSTALL_DIR/Home.md


