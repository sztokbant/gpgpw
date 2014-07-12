#!/bin/sh

# Bin config
GPG="/usr/local/bin/gpg"
EDITOR="vi"
SHRED="rm -P"

# Personal config
PWFILE="/Full/path/of/your/password/file.asc"
TMPFILE="/Full/path/for/unencrypted/tmp/file.txt"
GPGKEY="email.of@your.gpg.key"

case $1 in
"show")
  $GPG -d $PWFILE
  ;;

"edit")
  $GPG -o $TMPFILE -d $PWFILE && $EDITOR $TMPFILE
  while [ "$command" != "save" ] && [ "$command" != "discard" ]; do
    echo "Please enter either \"save\" or \"discard\": \c"
    read command
  done

  if [ "$command" = "save" ]; then
    $GPG -o $PWFILE -r $GPGKEY -e $TMPFILE && $SHRED $TMPFILE
  elif [ "$command" = "discard" ]; then
    $SHRED $TMPFILE
  fi
  ;;

*)
  echo "Usage: `basename $0` [show|edit]"
  ;;
esac
