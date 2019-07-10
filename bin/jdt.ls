#!/bin/sh

# https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Java

if test $(uname) = "Darwin"; then
  os=mac
elif test $(uname) = "Linux"; then
  os=linux
fi

jdt_dir=$TOOLS/local/opt/jdt.ls
launcher_jar=$jdt_dir/plugins/org.eclipse.equinox.launcher_1.5.300.v20190213-1655.jar
config_dir=$jdt_dir/config_$os

exec java \
  -Declipse.application=org.eclipse.jdt.ls.core.id1 \
  -Dosgi.bundles.defaultStartLevel=4 \
  -Declipse.product=org.eclipse.jdt.ls.core.product \
  -Dlog.level=ALL \
  -noverify \
  -Dfile.encoding=UTF-8 \
  -Xmx1G \
  -jar $launcher_jar \
  -configuration $config_dir \
  -data $(pwd)
  $@
