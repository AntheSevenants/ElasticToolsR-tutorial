# the location of the renv cache on the host machine
RENV_PATHS_CACHE_HOST=/opt/local/renv/cache

# where the cache should be mounted in the container
RENV_PATHS_CACHE_CONTAINER=/renv/cache

docker build \
    -f Dockerfile.base \
    -t anthesevenants/elastictoolsrtutorial:base .

docker build \
    -f Dockerfile.rstudio \
    -t anthesevenants/elastictoolsrtutorial:rstudio .