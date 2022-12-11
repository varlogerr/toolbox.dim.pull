# Docker image puller

Pull latest or all (currently hardcoded to 40 latest) images of a docker repository. For example `dim.pull.sh ubuntu` to download latest `ubuntu` image.

## Installation

```sh
# clone the repository
sudo git clone https://github.com/varlogerr/toolbox.dim.pull.git /opt/varlog/toolbox.dim.pull
# add '/opt/varlog/toolbox.dim.pull/bin' directory
# to the PATH manually
echo '. /opt/varlog/toolbox.dim.pull/source.bash' >> ~/.bashrc
# reload ~/.bashrc
. ~/.bashrc
# expore the script
dim.pull.sh -h
# set crontab to "pull-remove" 5 latest ubuntu
# images each monday at 4 AM
crontab - <<< \
  "0 4 * * 1 dim.pull.sh -l 5 -r ubuntu"   
```
