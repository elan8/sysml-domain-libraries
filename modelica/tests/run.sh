#!/usr/bin/env bash
# Checks every @ModelicaModel binding against its class (scripts/check_modelica_bindings.py), then
# compiles and simulates circuits of the bound classes with rumoca and checks the results against
# references derived without a simulator (check.py). Downloads the pinned rumoca release and the
# Modelica Standard Library into modelica/tests/.cache on first use; needs the GitHub CLI (`gh`).
set -euo pipefail

RUMOCA_VERSION=v0.10.4
MSL_VERSION=v4.1.0
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo="$(cd "$here/../.." && pwd)"
cache="$here/.cache"
out="$here/out"
mkdir -p "$cache" "$out"

rumoca="$cache/rumoca-$RUMOCA_VERSION"
if [[ ! -x "$rumoca" ]]; then
  gh release download "$RUMOCA_VERSION" -R CogniPilot/rumoca -p rumoca-linux-x86_64 -O "$rumoca" --clobber
  chmod +x "$rumoca"
fi
msl="$cache/msl-$MSL_VERSION"
if [[ ! -d "$msl" ]]; then
  gh release download "$MSL_VERSION" -R modelica/ModelicaStandardLibrary \
    -p "ModelicaStandardLibrary_${MSL_VERSION}.zip" -O "$cache/msl.zip" --clobber
  unzip -q "$cache/msl.zip" -d "$msl"
fi
roots=(--source-root "$repo/modelica/Elan8" --source-root "$msl/Modelica 4.1.0"
       --source-root "$msl/Complex.mo" --source-root "$msl/ModelicaServices 4.1.0")
tol=(--rtol 1e-9 --atol 1e-12)

python3 "$repo/scripts/check_modelica_bindings.py" --msl "$msl/Modelica 4.1.0"
"$rumoca" --version
sim() { # model output-step
  "$rumoca" sim "$here/Elan8Tests.mo" -m "Elan8Tests.$1" "${roots[@]}" "${tol[@]}" --dt "$2" -o "$out/$1.csv"
}
sim CellResistor 0.5
sim RcCharge 1e-5
sim NpnDriver 1e-5
sim PnpDriver 1e-5
sim CellCurrentSource 0.5
"$rumoca" sim "$repo/model/generic/physical-modeling/examples/mass-spring/models/MassSpring.mo" \
  -m Example.MassSpring "${tol[@]}" --dt 0.01 -o "$out/MassSpring.csv"

python3 "$here/check.py" "$out"
