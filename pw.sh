#!/bin/sh

# Bin config
GPG="/usr/local/bin/gpg"
EDITOR="vi"
SHRED="rm -P"

# Personal config
PWFILE="/Full/path/of/your/password/file.asc"
TMPFILE="/Full/path/for/unencrypted/tmp/file.txt"
GPGKEY="email.of@your.gpg.key"

do_cleanup() {
  $SHRED $TMPFILE
}

do_encrypt() {
  $GPG -o $PWFILE -r $GPGKEY -e $TMPFILE
}

case $1 in
"show")
  $GPG -d $PWFILE
  ;;

"edit")
  if [ ! -f $PWFILE ]; then
    touch $TMPFILE && do_encrypt && do_cleanup
  fi
  $GPG -o $TMPFILE -d $PWFILE && $EDITOR $TMPFILE
  while [ "$command" != "save" ] && [ "$command" != "discard" ]; do
    echo "Please enter either \"save\" or \"discard\": \c"
    read command
  done

  if [ "$command" = "save" ]; then
    do_encrypt && do_cleanup
  elif [ "$command" = "discard" ]; then
    do_cleanup
  fi
  ;;

*)
  echo "Usage: `basename $0` [show|edit]"
  ;;
esac
