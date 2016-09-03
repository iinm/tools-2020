tools_dir=$(cd $(dirname $0) && pwd)
test -f $tools_dir/setenv.local.sh && source $tools_dir/setenv.local.sh
#export PATH=$tools_dir/bin:$PATH
