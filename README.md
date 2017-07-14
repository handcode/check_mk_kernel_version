# check_mk_kernel_version

check_mk plugin to monitor if running kernel mach (last) installed version

Testet with FreeBSD and Debian, check cmds for others are welcome

## cli cmds to get installed and running kernel versions
### freeBSD:
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


## DEV hints

```
# test if check is found on server
check_mk -L | grep kernel_version_compare
kernel_version_compare                       tcp    (no man page present)

# test check on server
check_mk --checks=kernel_version_compare -I host01
[[u'10.3-RELEASE-p18', u'10.3-RELEASE-p18']]

# check debuggen
check_mk --debug -nv host01 | grep kernel-version

```

