set -e -u -x

export ANSIBLE_PACKAGE=${ANSIBLE_PACKAGE:-"ansible==2.4.4.0"}
export SSH_DIR=${SSH_DIR:-"/root/.ssh"}
export ANSIBLE_ROLE_FILE=${ANSIBLE_ROLE_FILE:-"ansible-role-requirements.yml"}
export ANSIBLE_BINARY=${ANSIBLE_BINARY:-"/opt/rpc-hummingbird-ansible-runtime/bin/ansible-playbook"}
# Set the role fetch mode to any option [galaxy, git-clone]
export ANSIBLE_ROLE_FETCH_MODE=${ANSIBLE_ROLE_FETCH_MODE:-git-clone}

# Prefer dnf over yum for CentOS.
which dnf &>/dev/null && RHT_PKG_MGR='dnf' || RHT_PKG_MGR='yum'

# This script should be executed from the root directory of the cloned repo
cd "$(dirname "${0}")/.."

source scripts/scripts-libs.sh
# Store the clone repo root location
export CLONE_DIR="$(pwd)"

# Set the variable to the role file to be the absolute path
ANSIBLE_ROLE_FILE="$(readlink -f "${ANSIBLE_ROLE_FILE}")"
OSA_INVENTORY_PATH="$(readlink -f playbooks/inventory)"
OSA_PLAYBOOK_PATH="$(readlink -f playbooks)"
# Create the ssh dir if needed
ssh_key_create

# Determine distro
determine_distro

# Install the base packages
case ${DISTRO_ID} in
    centos|rhel)
        yum -y install \
          git curl autoconf gcc gcc-c++ nc \
          python2 python2-devel \
          openssl-devel libffi-devel \
          libselinux-python
        ;;
    ubuntu)
        apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get -y install \
          git python-all python-dev curl python2.7-dev build-essential \
          libssl-dev libffi-dev netcat python-requests python-openssl python-pyasn1 \
          python-netaddr python-prettytable python-crypto python-yaml \
          python-virtualenv
        ;;
esac

PYTHON_EXEC_PATH="${PYTHON_EXEC_PATH:-$(which python2 || which python)}"
PYTHON_VERSION="$($PYTHON_EXEC_PATH -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')"

VIRTUALENV_VERSION=$(virtualenv --version 2>/dev/null | cut -d. -f1)
if [[ "${VIRTUALENV_VERSION}" -lt "13" ]]; then

  # Install pip on the host if it is not already installed,
  # but also make sure that it is at least version 7.x or above
  # so that it supports the use of the constraint option which
  # was added in pip 7.1.
  PIP_VERSION=$(pip --version 2>/dev/null | awk '{print $2}' | cut -d. -f1)
  if [[ "${PIP_VERSION}" -lt "7" ]]; then
    get_pip ${PYTHON_EXEC_PATH}
    # Ensure that our shell knows about the new pip
    hash -r pip
  fi

  pip install} \
    virtualenv==15.1.0 \
    || pip install \
         --isolated \
         virtualenv==15.1.0
  # Ensure that our shell knows about the new pip
  hash -r virtualenv
fi

pip install --requirement requirements.txt

# Create a Virtualenv for the Ansible runtime
if [ -f "/opt/rpc-hummingbird-ansible-runtime/bin/python" ]; then
  VENV_PYTHON_VERSION="$(/opt/rpc-hummingbird-ansible-runtime/bin/python -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')"
  if [ "$PYTHON_VERSION" != "$VENV_PYTHON_VERSION" ]; then
    rm -rf /opt/rpc-hummingbird-ansible-runtime
  fi
fi
virtualenv --python=${PYTHON_EXEC_PATH} \
           --clear \
           --no-pip --no-setuptools --no-wheel \
           /opt/rpc-hummingbird-ansible-runtime

# Install pip, setuptools and wheel into the venv
get_pip /opt/rpc-hummingbird-ansible-runtime/bin/python

# The vars used to prepare the Ansible runtime venv
if [ -f "/opt/rpc-hummingbird-ansible-runtime/bin/pip" ]; then
  PIP_COMMAND="/opt/rpc-hummingbird-ansible-runtime/bin/pip"
else
  PIP_COMMAND="$(which pip)"
fi
PIP_OPTS+=" --constraint global-requirement-pins.txt"

# Install ansible and the other required packages
${PIP_COMMAND} install ${PIP_OPTS} -r requirements.txt ${ANSIBLE_PACKAGE}

# Update dependent roles
if [ -f "${ANSIBLE_ROLE_FILE}" ]; then
  if [[ "${ANSIBLE_ROLE_FETCH_MODE}" == 'galaxy' ]];then
    # Pull all required roles.
    /opt/rpc-hummingbird-ansible-runtime/bin/ansible-galaxy install \
	--role-file="${ANSIBLE_ROLE_FILE}" --force
  elif [[ "${ANSIBLE_ROLE_FETCH_MODE}" == 'git-clone' ]];then
    pushd playbooks
      ${ANSIBLE_BINARY}  git-clone-repos.yml \
      		-i ${CLONE_DIR}/tests/inventory \
                -e role_file=${ANSIBLE_ROLE_FILE}
    popd
  else
    echo "Please set the ANSIBLE_ROLE_FETCH_MODE to either of the following options ['galaxy', 'git-clone']"
    exit 99
  fi
fi
