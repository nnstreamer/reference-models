
In order to use the zypper package on the target board,
you must download required packages at the http://download.tizen.org/ website.

* augeas-libs-1.12.0-9.2.armv7l.rpm
* bzip2-1.0.6-1.68.armv7l.rpm
* install.sh
* libsolv-0.6.35-2.17.armv7l.rpm
* libsolv-tools-0.6.35-0.armv7l.rpm
* libzypp-14.27.0-5.8.armv7l.rpm
* pacrunner-libproxy-0.9-2.13.armv7l.rpm
* zypper-1.11.11-6.1.armv7l.rpm

And then, please run a "rpm -ivh ./{package_name}.rpm --nodeps" command as follows on the target board.

``bash
board# rpm -ivh ./zypper-1.11.11-6.1.armv7l.rpm  --nodeps
board# rpm -ivh ./libzypp-14.27.0-5.8.armv7l.rpm  --nodeps
board# rpm -ihv ./augeas-libs-1.12.0-9.2.armv7l.rpm  --nodeps
board# rpm -ivh ./libsolv-0.6.35-2.17.armv7l.rpm  --nodeps
board# rpm -ivh ./pacrunner-libproxy-0.9-2.13.armv7l.rpm  --nodeps
board# rpm -ivh ./bzip2-1.0.6-1.68.armv7l.rpm
board# rpm -ivh ./libsolv-tools-0.6.35-0.armv7l.rpm
```

