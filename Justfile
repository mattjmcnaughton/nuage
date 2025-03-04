# === toolbox-vim config ===

image_uri := "docker.io/mattjmcnaughton/toolbox-vim"
version := "0.0.1"  # TODO: Update version to latest.
image_name := image_uri + ":" + version
cwd := `pwd`

vim:
  docker run -it \
    -v {{cwd}}:{{cwd}} \
    -w {{cwd}} \
    {{image_name}} \
    /bin/bash

# We run w/ `--network none` to disable any network access.
vim-offline:
  docker run -it \
    -v {{cwd}}:{{cwd}} \
    -w {{cwd}} \
    --network none \
    {{image_name}} \
    /bin/bash
