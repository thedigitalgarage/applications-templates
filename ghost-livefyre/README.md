# Ghost LiveFyre

### Create new project

`oc new-project ghost-livefyre`

### Add template to namespace

`oc create -f https://raw.githubusercontent.com/thedigitalgarage/applications-templates/master/ghost-livefyre/ghost-template.json`

Templates can be added with local files or remote, in this case use the remote raw file.

### Add new application to the project

`oc new-app ghost-mysql-digital-garage --param "APPLICATION_DOMAIN=http://ghost-ghost.apps.10.2.2.2.xip.io/" --param "LIVEFYRE_SITEID=$SITEID"`

LiveFyre SiteId can be created on http://web.livefyre.com/comments/ 
