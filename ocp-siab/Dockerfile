FROM centos:7

MAINTAINER Louis P. Santillan <lpsantil@gmail.com>

WORKDIR /tmp

# Run as root
USER 0

# Add our init script
ADD startsiab.sh /opt/startsiab.sh
# Fix up the Reverse coloring
ADD black-on-white.css /usr/share/shellinabox/black-on-white.css
# Add nano syntax highlighting for Dockerfiles
ADD dockerfile.nanorc /usr/share/nano/dockerfile.nanorc
# Add nano syntax highlighting for JS
ADD javascript.nanorc /usr/share/nano/javascript.nanorc
# Enable nano syntax highlighting
ADD nanorc /tmp/nanorc

# Install EPEL
# Install our developer tools (tmux, ansible, nano, vim, bash-completion, wget)
# Install oc
# Free up some space
# Add our default user
# Bring in nano's user config
# Give nano's user config the correct ownership
# Set the default password for our user
# Randomize root's password
# Be sure to remove login's lock file
# Tell PAM to use sessions
#    mkdir /var/run/sshd && \
#    ssh-keygen -A && \
#    sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config && \
#    /usr/bin/sshd && \
##    echo "%root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/root-group && \
#    mkdir /var/run/sshd && \
#    chmod -R 666 /etc/ssh && \
#    sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config && \
#    chmod -R 777 /etc && \
#    echo "developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/developer && \
#    sed -i '/pam_loginuid.so/c\#session    required     pam_loginuid.so' /etc/pam.d/login && \
#    sed -i '/pam_loginuid.so/c\#session    required     pam_loginuid.so' /etc/pam.d/remote && \
RUN yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm && \
    yum install -y jq vim screen which hostname passwd tmux nano wget git bash-completion openssl shellinabox util-linux expect --enablerepo=epel && \
    yum clean all && \
    cd /tmp/ && \
    wget https://github.com/openshift/origin/releases/download/v3.10.0/openshift-origin-client-tools-v3.10.0-dd10d17-linux-64bit.tar.gz && \
    ls -lah /tmp/ && \
    echo "=== Untar'ing 'oc' ===" && \
    tar zxvf /tmp/openshift-origin-client-tools-v3.10.0-dd10d17-linux-64bit.tar.gz && \
    echo "=== Copying 'oc' ===" && \
    mv -v /tmp/openshift-origin-client-tools-v3.10.0-dd10d17-linux-64bit/oc /usr/local/bin/ && \
    useradd -u 1001 developer -m && \
    mkdir -pv /home/developer/bin /home/developer/tmp && \
    mv -v /tmp/nanorc /home/developer/.nanorc && \
    chown 1001:1001 /home/developer/.nanorc && \
    ( echo "developer" | passwd developer --stdin ) && \
    ( cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 128 | head -n 1 | passwd root --stdin ) && \
    rm -f /var/run/nologin && \
    echo "Done building siab container"

# shellinabox will listen on 8080
EXPOSE 8080

# Run as developer
USER 1001

# Run our init script
CMD /opt/startsiab.sh
