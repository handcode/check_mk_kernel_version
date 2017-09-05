# check_mk_kernel_version

check_mk plugin to monitor if running kernel mach (last) installed version

Testet with FreeBSD and Debian, check cmds for others are welcome

## cli cmds to get installed and running kernel versions
### FreeBSD:
#### running kernel

    sysctl -n kern.osrelease 
    10.3-RELEASE-p11

#### installed kernel

    freebsd-version -k 
    10.3-RELEASE-p11

### debian/ubuntu
#### running:

    sysctl -n kernel.version | awk '{print $4}'
    3.16.39-1+deb8u2

#### installed 

    dpkg -l | grep linux-image-$(uname -r) | awk '{print $3}'
    3.16.39-1+deb8u2


## Install

### OMD Server Install

#### check_mk package:
```
cmk -vP releases/kernel_version_compare-<VERSION>.mkp
```

#### manually:
```
cp checks/kernel_version_compare /omd/sites/$(OMD_SITE)/local/share/check_mk/checks/
cp plugins/kernel_version_compare /omd/sites/$(OMD_SITE)/local/share/check_mk/agents/plugins/
cp packages/kernel_version_compare /omd/sites/$(OMD_SITE)/var/check_mk/packages/
```  

#### use make target:
```
usage: make [target ...]

pkg:
  pkg......................alias for package
  package..................build check_mk package from installed repo files
  release..................build check_mk package and copy *.mkp file to repo

dev:
  install..................install check_mk plugin, optional OMD_SITE=cfa can be overwritten
  purge....................purge check_mk plugin files, optional OMD_SITE=cfa can be overwritten

system:
  help.....................show this help
```

### Client Install
```
cp plugins/kernel_version_compare /usr/lib/check_mk_agent/plugins/kernel_version_compare
```
Or download plugin from OMD Server, or rollout plugin with puppet ;-)


## DEV hints

```
# test if check is found on server
check_mk -L | grep kernel_version_compare
kernel_version_compare                       tcp    (no man page present)

# test check on server
check_mk -v --checks=kernel_version_compare host01.example.com

Calling external program ssh -o ConnectTimeout=10 -l monitor 192.168.1.1
Kernel-Version FreeBSD OK - Kernel version running 10.3-RELEASE-p20 match installed version
OK - Agent version 1.2.6p12, execution time 0.7 sec|execution_time=0.655 user_time=0.280 system_time=0.020 children_user_time=0.000 children_system_time=0.000

```

