# infrastructure-runner
GitHub Runner container. To successfully run this container you will need to
set three environment variables.

* `GITHUB_RUNNER_OWNER` - set this to the name of the organization that the runner will associate with.
* `GITHUB_RUNNER_NAME` - set this to a unique name within your organization
* `GITHUB_TOKEN` - set this to a GitHub Personal Access Token with "admin:org" permissions.

You will also need to either mount a Docker socket or tell the container where it can connect to Docker by setting a `DOCKER_HOST` environment variable.

Finally, you will need to mount a path that can be seen by Docker and by the runner. They both need to see it at the same location, too. This container expects that path to be `/opt/runner` so make sure that `/opt/runner` is visible to wherever Docker is running. The easiest way to do this is to create a Kubernetes pod with this container and a "Docker-in-Docker" container and both containers have an `emptyDir` mounted into them at `/opt/runner`. See the example directory for a configuration example.

Then the container will start up and download the latest version of the runner and run it until a new version is released at which point the container will crash. If you have it configured to restart automatically then it should have the latest version of the runner on startup and not crash again. [See this issue for why GitHub does not care that your container is crashing.](https://github.com/actions/runner/issues/485)
