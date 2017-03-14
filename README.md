## freeBSD:
### running kernel

    sysctl -n kern.osrelease 
    10.3-RELEASE-p11

### installed kernel

    freebsd-version -k 
    10.3-RELEASE-p11

## debain/ubuntu
### running:

    sysctl -n kernel.version
    #1 SMP Debian 3.16.39-1 (2016-12-30)

### installed 

    dpkg -l | grep linux-image-$(uname -r) | awk '{print $3}'
    3.16.39-1+deb8u2
  