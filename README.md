This repo allows for starting up a Dockerised deployment server that contains everything necessary to deploy the web app in the "web" repo.

Currently there is no deployment server running.  One can be setup easily by starting up a CoreOS instance on Digital Ocean or with a bit more effort, a CoreOS instance on AWS and doing the following:

* check out this repo
* ./run build 
	- this will build the deployment server image
* ./run bash
	- this will launch a container for the server image built above and launch a bash shell, that can be used to do deployements

# On the built deployment server:

* ./run deploy app env [version]
	-  where app can be one of "ca" or "nz" (corresponding to the ca and nz folders) and env can be one of the environments that can be discovered by doing a "eb list" in each of the ca and nz folders
	- a naming convention is used of app-env for the environments returned by eb list. Examples of environments are "qa" and "staging
	- if version is ommitted, then the latest code will be checked out from build/web, a new Docker image created and pushed to DockerHub.  The image then gets deployed by the AWS EB CLI, which works by reading the Dockerrun.aws.json file in the applicable ca or nz folder for getting the details for which app version to deploy and which bucket to use for the DockerHub credentials.  Each app has to have a copy of the DockerHub credentials in S3 (an AWS requirement).  These credentials have already been uploaded to the buckets for the existing apps.  A file in the ca / nz folder called "v" gets updated, so that a new version can get staged when ommitting version when issuing the command, otherwise "eb deploy" deploys the previous staged version.
	- if version is specified, then the tag with the version number gets checked out in build/web if the tag exists.  This is so that db_version can be used for the database migration.  It is important to make sure that a tag exists for the version specified.  The image with that tag will get deployed if it exists, otherwise a new image will get created and deployed.
	- because the CMS hadn't been finished yet and managed content is currently read from build/web/_content, the appropriate content branch need to be checked out manually before deploying the app
	- database migrations are automatically applied after each deploy to AWS

Details of the above can be seen in server/run.

# In AWS configuration

* allow access to database instance from the IP address of the deployment server, for being able to apply migrations and fixtures

TODO:

* script the creation of the applications and databases in AWS, security roles and environments.  This was done through the AWS management console, but should be scripted so that applications and environments can be automatically re-created if needed instead of having to do it manually again.

* use Ansible for all of the above

