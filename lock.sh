function getlock()
{
  local LBASE TEMPFILE LOCKFILE

  LBASE="$1"
  if [ -z "$LBASE" ]; then
    error "Parameter 'lbase' not specified in function 'getlock()'."
  fi

  TEMPFILE="$LBASE.$$"
  LOCKFILE="$LBASE.lock"

  # write pid and try to get lock soft-linking pid-file
  ( echo "$$" > "$TEMPFILE" ) >& /dev/null || {
    error "You don't have permission to access `dirname "$TEMPFILE"`"
    return 1
  }
  ln "$TEMPFILE" "$LOCKFILE" >& /dev/null && {
    # oh yeah! i got it!
    rm -f "$TEMPFILE"
    return 0
  }
  # i couldn't lock that file... check if process that created it exists
  kill -0 `cat "$LOCKFILE"` >& /dev/null && {
    rm -f "$TEMPFILE"
    return 1
  }
  warning "Removing stale lock file"
  rm -f "$LOCKFILE"
  # try to get lock...
  ln "$TEMPFILE" "$LOCKFILE" >& /dev/null && {
    rm -f "$TEMPFILE"
    return 0
  }
  # sht
  rm -f "$TEMPFILE"
  return 1
}

function releaselock()
{
  local LBASE

  LBASE="$1"
  if [ -z "$LBASE" ]; then
    error "Parameter 'lbase' not specified in function 'releaselock()'."
  fi

  rm -f "$LBASE.lock"
}

