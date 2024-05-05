#!/bin/bash
# Copyright (c) godot-rust; Bromeon and contributors.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# Sets up a patch in Cargo.toml to use godot4-prebuilt artifacts.
# Input: $version

version="$1"

# Add correct feature to `godot` dependency.
if [[ "$version" == "nightly" ]]; then
  # Do not use extraFeatures="custom-godot" here. They just want to use nightly Godot with current API.
  extraFeatures=""
else
  # Extract "major.minor" from "major.minor[.patch]".
  dashedVersion=$(echo "$version" | cut -d '.' -f 1,2 | sed 's/\./-/')
  extraFeatures=", \"api-$dashedVersion\""
fi

# Add extra features to the godot dependency (expects existing `features` key).
sed -i "/^godot = /s/\(features = \[\([^]]*\)\)\]/\1$extraFeatures]/g" itest/rust/Cargo.toml

echo "Patched Cargo.toml for version $version$extraFeatures."
