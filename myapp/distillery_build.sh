#!/usr/bin/env bash
MIX_ENV=prod mix do deps.get --only prod, compile
#boot build && MIX_ENV=prod mix do phx.digest, release --env=prod
MIX_ENV=prod mix release --env=prod
