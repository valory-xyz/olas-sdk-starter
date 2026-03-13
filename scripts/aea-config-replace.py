#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# ------------------------------------------------------------------------------
#
#   Copyright 2021-2025 Valory AG
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
# ------------------------------------------------------------------------------


"""Updates fetched agent with correct config"""

import os
from pathlib import Path

import yaml
from dotenv import load_dotenv  # type: ignore


def main() -> None:
    """Main"""
    load_dotenv()

    with open(Path("hello_world", "aea-config.yaml"), "r", encoding="utf-8") as file:
        config = list(yaml.safe_load_all(file))

        # Params

        if os.getenv("ALL_PARTICIPANTS"):
            config[1]["models"]["params"]["args"]["setup"][
                "all_participants"
            ] = f"${{list:{os.getenv('ALL_PARTICIPANTS')}}}"  # type: ignore

    with open(Path("hello_world", "aea-config.yaml"), "w", encoding="utf-8") as file:
        yaml.dump_all(config, file, sort_keys=False)


if __name__ == "__main__":
    main()
