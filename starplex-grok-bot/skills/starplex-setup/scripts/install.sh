#!/bin/sh
# Installs Node 26 beside any existing Node, the Starplex CLI, and a
# starplex-bot command that runs the CLI with Node 26. Safe to run again.
set -eu
# Never replace a starplex command that someone else wrote, such as a
# wrapper that runs the CLI with its own Node: their connector may run it.
entry="$HOME/.local/bin/starplex"
if [ -e "$entry" ] && ! grep -q "This file stays as the install wrote it" "$entry"; then
  echo "$entry exists and wasn't written by the Starplex installer, so this script stopped without changing anything." >&2
  exit 3
fi
case "$(uname -m)" in
  x86_64) arch=x64 ;;
  aarch64) arch=arm64 ;;
  *) echo "unsupported machine" >&2; exit 1 ;;
esac
cd "$(mktemp -d)"
get() { curl -fsSL --connect-timeout 10 --max-time 300 "$@"; }
get -O https://nodejs.org/dist/latest-v26.x/SHASUMS256.txt
archive=$(grep -o "node-v26[0-9.]*-linux-$arch.tar.gz" SHASUMS256.txt | head -n 1)
get -O "https://nodejs.org/dist/latest-v26.x/$archive"
grep " $archive\$" SHASUMS256.txt | sha256sum -c -
mkdir -p "$HOME/.local/share/node26" "$HOME/.local/bin"
tar -xzf "$archive" --strip-components=1 -C "$HOME/.local/share/node26"
export PATH="$HOME/.local/share/node26/bin:$HOME/.local/bin:$PATH"
get -o install.sh https://app.starplex.dev/install.sh
sh install.sh
cat > "$HOME/.local/bin/starplex-bot" <<'WRAPPER'
#!/bin/sh
export PATH="$HOME/.local/share/node26/bin:$HOME/.local/bin:$PATH"
exec "$HOME/.local/bin/starplex" "$@"
WRAPPER
chmod +x "$HOME/.local/bin/starplex-bot"
"$HOME/.local/bin/starplex-bot" --version
echo "Full command path: $HOME/.local/bin/starplex-bot"
