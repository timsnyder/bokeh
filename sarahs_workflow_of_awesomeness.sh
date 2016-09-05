#!/usr/bin/bash

# assuming you are already in your conda dev environment...

set -x 

# kick off a simple local python webserver to be able to browse your machine via http
gnome-terminal --working-directory=/ -e 'python -m http.server 8005'

# do initial build of bokehjs
(cd bokehjs && gulp build)

#on jscript side she runs 'gulp watch' to have the js get rebuilt automagically
#if you make python changes, you will have to rerun the python script and then reload the webpage
gnome-terminal --tab --working-directory=./bokehjs -e gulp watch



cat <<END
Now you can run any example script like using either:
BOKEH_DEV=true python ./examples/../foo.py

Brian doesn't use BOKEH_DEV yet but Sarah does.  He showed me:
BOKEH_RESOURCES=inline BOKEH_LOG_LEVEL=debug python ./examples/../foo.py
but BOKEH_DEV=true should contain the same behavior according to bokeh/settings.py


END


