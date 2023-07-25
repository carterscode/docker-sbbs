#!/usr/bin/env bats

@test "Environment variable are set" {
  run test -n $SBBSDIR
  run test -n $SBBSCTRL
  [ "$status" -eq 0 ]
}

@test "SBBSDIR exists" {
  run test -d $SBBSDIR
  [ "$status" -eq 0 ]
}

@test "SBBSDIR/exec/sbbs is executable" {
  run test -x $SBBSDIR/exec/sbbs
  [ "$status" -eq 0 ]
}