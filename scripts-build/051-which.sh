#!/usr/bin/bash
set -exuo pipefail

# The OS ships no `which`: busybox (its WHICH applet) is disabled and coreutils
# does not provide one. Install a small shim over the `command -v` bash builtin
# so the command exists in the booted system.
#
# NOTE: this only adds `which` to the OS image ($INITRAMFS_DIR). Build scripts
# run in the build container and must keep using `command -v` directly.
install -d "$INITRAMFS_DIR/usr/bin"

cat >"$INITRAMFS_DIR/usr/bin/which" <<'EOF'
#!/usr/bin/bash
# Minimal which(1): print the absolute path of each command, resolved via the
# shell builtin `command -v`. Flags are ignored; builtins/functions/aliases
# (which `command -v` reports as a bare name) are treated as not found.
ret=0
for arg in "$@"; do
	case $arg in
	-*) continue ;;
	esac
	if p=$(command -v -- "$arg") && [ "${p#/}" != "$p" ]; then
		printf '%s\n' "$p"
	else
		ret=1
	fi
done
exit $ret
EOF

chmod +x "$INITRAMFS_DIR/usr/bin/which"
