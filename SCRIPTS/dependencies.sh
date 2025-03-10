# This is a script that installs all the dependencies for the project
# It works well on:
#  - Ubuntu/Debian
#  - Fedora
#  - Arch

# Check if the user is root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Check the OS as flag
if [ -f /etc/debian_version ]; then
  OS="debian"
elif [ -f /etc/fedora-release ]; then
  OS="fedora"
elif [ -f /etc/arch-release ]; then
  OS="arch"
else
  echo "This script only works on Debian, Fedora and Arch"
  exit
fi

# Install the dependencies from the list
# skip the pkg if not found and continue
# skip the pkg if already installed
# ask me if there are any packages that are conflicting
# print the installed packages at the end

# Debian
if [ "$OS" == "debian" ]; then
  while read pkg; do
    if dpkg -s $pkg 2>/dev/null | grep -q "Status: install ok installed"; then
      echo "$pkg is already installed"
    else
      apt-get install -y $pkg
    fi
  done < $DOTFILES_SCRIPTS/dependencies.list
fi

# Fedora
if [ "$OS" == "fedora" ]; then
  while read pkg; do
    if rpm -q $pkg 2>/dev/null; then
      echo "$pkg is already installed"
    else
      dnf install -y $pkg
    fi
  done < $DOTFILES_SCRIPTS/dependencies.list
fi

# Arch
if [ "$OS" == "arch" ]; then
  while read pkg; do
    if pacman -Q $pkg 2>/dev/null; then
      echo "$pkg is already installed"
    else
      pacman -S --noconfirm $pkg
    fi
  done < $DOTFILES_SCRIPTS/dependencies.list
fi

