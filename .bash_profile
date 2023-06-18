# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

PATH="/snap/bin:$PATH"

# OpenJDK
. /var/snap/openjdk/current/openjdk.env

PATH="$PATH:/opt/apache-maven-3.6.3/bin"

# linkerd CLI
PATH="$PATH:$HOME/.linkerd2/bin"

# go
PATH="$PATH:/usr/local/go/bin"

# export LD_LIBRARY_PATH="$HOME/.local/lib"
# export LD_RUN_PATH="$LD_LIBRARY_PATH"
export MANPATH="$MANPATH:$HOME/.local/share/man"
