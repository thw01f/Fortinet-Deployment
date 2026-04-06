#!/bin/bash
#==============================================================================
#  crafted by wolf
#==============================================================================

# ── Config ───────────────────────────────────────────────────────────────────
STATE_FILE="$HOME/.wolf_setup_state"
LOG_FILE="$HOME/.wolf_setup.log"
FORTINET_DIR="$HOME/Documents/Fortinet"
IMG_DIR="/var/lib/libvirt/images"
NETWORK="default"
MAX_RETRIES=3

FGT_RAM=2048; FGT_CPU=1
FAZ_RAM=4096; FAZ_CPU=2
FMG_RAM=4096; FMG_CPU=2
FAZ_DATA_SIZE="200G"
FMG_DATA_SIZE="200G"

# ── Colors ───────────────────────────────────────────────────────────────────
R='\033[1;31m'; G='\033[1;32m'; Y='\033[1;33m'; C='\033[1;36m'; M='\033[1;35m'
B='\033[1;34m'; W='\033[1;37m'; D='\033[0;90m'; RST='\033[0m'
BG_G='\033[42m'; BG_D='\033[100m'

# ── Wolf Banner ──────────────────────────────────────────────────────────────
banner() {
    clear
    echo -e "${W}"
    cat << 'EOF'
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣶⠶⢦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠁⠀⠸⠛⢳⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠃⠀⠀⠀⠀⣿⠹⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠃⠀⠀⠀⠀⠀⣿⠀⢿⠀⣴⠟⠷⣆⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⠃⠀⠀⠀⠀⢀⣤⡟⠀⢸⣿⠃⠀⠀⠘⣷⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⠁⠀⠀⠀⠀⠀⣸⡿⠿⠟⢿⡏⠀⠀⠀⢀⣿⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣤⣾⠟⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⣼⡇⠀⠀⠀⣸⡏⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡾⠛⡋⠉⣩⡇⠀⠀⠀⠀⠀⠀⠀⠀⠘⣷⣰⠟⠋⠁⠀⠀⢠⡟⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠏⢠⡞⣱⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠟⠀⠀⠀⠀⠀⣾⠃⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠃⢀⣿⢁⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀⣠⢰⣿⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡾⠁⠀⢸⣿⣿⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⢀⣶⣾⡇⢸⣧⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡿⠀⠀⠀⢸⣿⣿⣾⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣏⣠⢰⢻⡟⢃⡿⡟⣿⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⡇⠀⠀⠀⠀⠁⢿⠹⣿⣄⠀⠀⠀⢀⠀⠀⠀⠀⢺⠏⣿⣿⠼⠁⠈⠰⠃⣿⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⡟⠃⠀⠈⢻⣷⣄⠈⠁⣿⣿⡇⠀⠀⠈⣧⠀⠀⠀⠘⣠⠟⠁⠀⠀⠀⠀⠀⢻⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢀⣾⠟⠀⠀⣴⠀⠀⣿⡿⠀⠸⠋⢸⣿⣧⡐⣦⣸⡆⠀⠀⠈⠁⠀⠀⠀⠀⠀⠀⠀⠘⣿⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣠⡿⠃⠀⣀⣴⣿⡆⢀⣿⠃⠀⠀⠀⣸⠟⢹⣷⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣧⠀⠀⠀⠀⠀⠀
⠀⠀⠀⣀⣤⣾⡏⠛⠻⠿⣿⣿⣿⠁⣼⠇⠀⠀⠀⠀⠁⠀⢸⣿⠙⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣇⠀⠀⠀⠀⠀
⠲⢾⣿⣿⣿⣿⣇⢀⣠⣴⣿⡿⢁⣼⣿⣀⠀⠀⠀⠀⠀⠀⠈⢿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣆⠀⠀⠀⠀
⠀⠀⠉⠙⠛⠻⣿⣷⣶⣿⣷⠾⣿⣵⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠙⠀⠀⠀⠀⠀⠀⠀⢤⡀⠀⠀⠀⠀⠀⠀⠀⡀⢿⡆⠀⠀⠀
⠀⠀⠀⠀⠀⣰⣿⡟⣴⠀⠀⠉⠉⠁⢿⡇⣴⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡆⠀⠀⠀⠀⣴⠀⣿⣿⣿⠀⠀⠀
⠀⠀⠀⠀⢠⣿⠿⣿⣿⢠⠇⠀⠀⠀⢸⣿⢿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣀⠀⠀⢸⣿⡄⠀⠀⣼⣿⣇⢹⡟⢿⡇⠀⠀
⠀⠀⠀⠀⣿⠃⣠⣿⣿⣿⠀⠀⠀⠀⠀⢻⡈⢿⣆⠀⢳⡀⠀⢠⠀⠀⠀⠀⠀⢸⣿⣦⠀⣸⠿⣷⡀⠀⣿⣿⢿⣾⣿⠸⠇⠀⠀
⠀⠀⠀⠀⠋⣰⣿⣿⣿⣿⡀⢰⡀⠀⠀⠀⠀⠈⢻⣆⣼⣷⣄⠈⢷⡀⠀⠀⠀⢸⣿⢿⣶⠟⠀⠙⣷⣼⣿⣿⡄⠻⣿⣧⡀⠀⠀
⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣧⡿⠀⠀⠀⠀⠀⠀⠀⠙⢿⡄⠻⣷⣼⣿⣦⡀⠀⣼⠇⠸⠋⠀⠀⠀⠈⠻⣿⣿⣷⡀⠈⠻⣷⡀⠀
⠀⠀⠀⠀⠀⣿⣼⡿⢻⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠀⠈⠻⣷⡙⣿⣶⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣷⢠⣀⠘⣷⡀
⠀⠀⠀⠀⠀⠀⣿⠇⣾⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠈⠛⢿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⠀⢻⣷⣾⡇
⠀⠀⠀⠀⠀⠀⣿⢠⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠓⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠀⢈⣿⡹⣷
⠀⠀⠀⠀⠀⠀⠈⠀⠻⠿⠿⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⡇⠉
EOF
    echo -e "${RST}"
    echo -e "${D}──────────────────────────────────────────────────────────────────────${RST}"
    echo -e "${M}              ⚡ IST Cybersecurity Lab Setup ⚡${RST}"
    echo -e "${D}                       crafted by wolf${RST}"
    echo -e "${D}──────────────────────────────────────────────────────────────────────${RST}"
    echo ""
}

# ── Animations ───────────────────────────────────────────────────────────────

# Spinner — runs in background, call stop_spinner to kill
SPINNER_PID=""
SPINNER_FRAMES=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")

start_spinner() {
    local msg="$1"
    (
        local i=0
        while true; do
            printf "\r  ${C}${SPINNER_FRAMES[$((i % ${#SPINNER_FRAMES[@]}))]}${RST} ${D}%s${RST}  " "$msg"
            sleep 0.1
            ((i++))
        done
    ) &
    SPINNER_PID=$!
    disown $SPINNER_PID 2>/dev/null
}

stop_spinner() {
    local success="${1:-true}"
    if [[ -n "$SPINNER_PID" ]] && kill -0 "$SPINNER_PID" 2>/dev/null; then
        kill "$SPINNER_PID" 2>/dev/null
        wait "$SPINNER_PID" 2>/dev/null
    fi
    SPINNER_PID=""
    printf "\r\033[K"  # clear the spinner line
}

# Typing effect
typewrite() {
    local text="$1" delay="${2:-0.02}"
    for (( i=0; i<${#text}; i++ )); do
        printf '%s' "${text:$i:1}"
        sleep "$delay"
    done
    echo ""
}

# Progress bar — overall step progress
progress_bar() {
    local current="$1" total="$2" width=40
    local filled=$(( current * width / total ))
    local empty=$(( width - filled ))
    local pct=$(( current * 100 / total ))

    local bar=""
    for (( i=0; i<filled; i++ )); do bar+="█"; done
    for (( i=0; i<empty; i++ )); do bar+="░"; done

    echo -e "  ${C}[$bar]${RST} ${W}${pct}%${RST}  ${D}(${current}/${total})${RST}"
}

# Wolf run animation — shown between steps
wolf_run() {
    local frames=(
        "  🐺        "
        "    🐺      "
        "      🐺    "
        "        🐺  "
        "          🐺"
        "        🐺  "
        "      🐺    "
        "    🐺      "
    )
    for frame in "${frames[@]}"; do
        printf "\r${D}%s${RST}" "$frame"
        sleep 0.08
    done
    printf "\r\033[K"
}

# Countdown with animation (used before big operations)
countdown() {
    local msg="$1" secs="${2:-3}"
    for (( i=secs; i>0; i-- )); do
        printf "\r  ${Y}⏳${RST} ${D}%s in %d...${RST}  " "$msg" "$i"
        sleep 1
    done
    printf "\r\033[K"
}

# ── Logging ──────────────────────────────────────────────────────────────────
log()  { echo -e "${G}[✔]${RST} $1"; echo "[$(date '+%H:%M:%S')] OK: $1" >> "$LOG_FILE"; }
warn() { echo -e "${Y}[!]${RST} $1"; echo "[$(date '+%H:%M:%S')] WARN: $1" >> "$LOG_FILE"; }
err()  { echo -e "${R}[✖]${RST} $1"; echo "[$(date '+%H:%M:%S')] ERR: $1" >> "$LOG_FILE"; }
info() { echo -e "${C}[i]${RST} $1"; }

step_header() {
    echo ""
    wolf_run
    echo -e "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RST}"
    echo -ne "  ${W}"
    typewrite "STEP $1 ▸ $2" 0.03
    echo -ne "${RST}"
    echo -e "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RST}"
    progress_bar "$1" "$TOTAL_STEPS"
}

# ── Run command with spinner (visible output) ────────────────────────────────
# For commands where we want to see apt output etc.
run_visible() {
    local desc="$1"; shift
    echo -e "  ${C}▸${RST} ${D}$desc${RST}"
    "$@" 2>>"$LOG_FILE"
    return $?
}

# ── Run command with spinner (hidden output) ─────────────────────────────────
run_silent() {
    local desc="$1"; shift
    start_spinner "$desc"
    "$@" >>"$LOG_FILE" 2>&1
    local rc=$?
    stop_spinner
    if (( rc == 0 )); then
        echo -e "  ${G}✔${RST} $desc"
    else
        echo -e "  ${R}✖${RST} $desc"
    fi
    return $rc
}

# ── Error handler with auto-fix ──────────────────────────────────────────────
try_fix() {
    local desc="$1"
    local cmd="$2"
    local fix_cmd="${3:-}"
    local silent="${4:-false}"
    local attempt=1

    while (( attempt <= MAX_RETRIES )); do
        info "Attempt $attempt/$MAX_RETRIES: $desc"

        if [[ "$silent" == "true" ]]; then
            start_spinner "$desc"
            eval "$cmd" >>"$LOG_FILE" 2>&1
            local rc=$?
            stop_spinner
            if (( rc == 0 )); then
                echo -e "  ${G}✔${RST} $desc"
                return 0
            fi
        else
            if eval "$cmd" 2>>"$LOG_FILE"; then
                return 0
            fi
        fi

        err "Failed: $desc (attempt $attempt)"

        # Explicit fix
        if [[ -n "$fix_cmd" ]]; then
            start_spinner "Applying fix..."
            eval "$fix_cmd" >>"$LOG_FILE" 2>&1 || true
            stop_spinner
        fi

        # Pattern-based auto-fixes
        local last_err
        last_err=$(tail -10 "$LOG_FILE" 2>/dev/null)

        if echo "$last_err" | grep -qi "dpkg.*lock\|Could not get lock"; then
            start_spinner "Fixing dpkg locks..."
            sudo rm -f /var/lib/dpkg/lock-frontend /var/lib/apt/lists/lock /var/cache/apt/archives/lock 2>/dev/null
            sudo dpkg --configure -a 2>/dev/null || true
            stop_spinner
            warn "Cleared stale locks"
        fi

        if echo "$last_err" | grep -qi "dpkg was interrupted\|configure -a"; then
            start_spinner "Running dpkg --configure -a..."
            sudo dpkg --configure -a 2>/dev/null || true
            stop_spinner
            warn "dpkg reconfigured"
        fi

        if echo "$last_err" | grep -qi "Broken\|unmet dependencies\|broken packages"; then
            start_spinner "Repairing broken packages..."
            sudo apt --fix-broken install -y 2>/dev/null || true
            stop_spinner
            warn "Broken packages repaired"
        fi

        if echo "$last_err" | grep -qi "NO_PUBKEY\|GPG error\|not signed"; then
            start_spinner "Refreshing Kali keyring..."
            sudo apt install -y kali-archive-keyring 2>/dev/null || true
            stop_spinner
            warn "Keyring refreshed"
        fi

        if echo "$last_err" | grep -qi "Temporary failure\|Could not resolve\|connection timed out"; then
            local wait_secs=10
            for (( w=wait_secs; w>0; w-- )); do
                printf "\r  ${Y}⏳${RST} ${D}Network error — retrying in %d...${RST}  " "$w"
                sleep 1
            done
            printf "\r\033[K"
            sudo systemctl restart NetworkManager 2>/dev/null || true
            sleep 3
        fi

        if echo "$last_err" | grep -qi "libvirt\|virsh.*connect\|Failed to connect"; then
            start_spinner "Restarting libvirtd..."
            sudo systemctl restart libvirtd 2>/dev/null || true
            sleep 3
            stop_spinner
            warn "libvirtd restarted"
        fi

        if echo "$last_err" | grep -qi "Permission denied.*qcow2\|Cannot access storage"; then
            start_spinner "Fixing image permissions..."
            sudo chown libvirt-qemu:kvm "$IMG_DIR"/*.qcow2 2>/dev/null || true
            sudo chmod 660 "$IMG_DIR"/*.qcow2 2>/dev/null || true
            sudo chmod o+x /var/lib/libvirt /var/lib/libvirt/images 2>/dev/null || true
            stop_spinner
            warn "Permissions fixed"
        fi

        ((attempt++))
        sleep 2
    done

    err "FAILED after $MAX_RETRIES attempts: $desc"
    echo -ne "${Y}  ▸ Skip and continue? [Y/n]: ${RST}"
    read -r ans
    [[ "${ans,,}" != "n" ]] && return 0
    echo -e "${R}  Aborting. Re-run the script to resume.${RST}"
    exit 1
}

# ── State ────────────────────────────────────────────────────────────────────
get_state() { [[ -f "$STATE_FILE" ]] && cat "$STATE_FILE" || echo "0"; }
set_state() { echo "$1" > "$STATE_FILE"; }

# ══════════════════════════════════════════════════════════════════════════════
#  STEPS
# ══════════════════════════════════════════════════════════════════════════════

step1_update() {
    step_header 1 "APT Update"
    try_fix "apt update" \
        "sudo apt update -y" \
        "sudo apt clean && sudo rm -rf /var/lib/apt/lists/* && sudo apt update -y"
    set_state 1; log "APT update complete"
}

step2_upgrade() {
    step_header 2 "APT Full Upgrade"
    countdown "Starting full upgrade"
    try_fix "apt full-upgrade" \
        "sudo DEBIAN_FRONTEND=noninteractive apt full-upgrade -y"
    set_state 2; log "APT upgrade complete"
}

step3_install_kvm() {
    step_header 3 "Install KVM / Libvirt / Virt-Manager"
    try_fix "install KVM stack" \
        "sudo DEBIAN_FRONTEND=noninteractive apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager virtinst unzip cpu-checker os-prober" \
        "sudo apt --fix-broken install -y"
    try_fix "enable libvirtd" \
        "sudo systemctl enable --now libvirtd" "" "true"
    run_silent "add user to libvirt group" sudo usermod -aG libvirt "$(whoami)"
    run_silent "add user to kvm group" sudo usermod -aG kvm "$(whoami)"
    set_state 3; log "KVM stack installed"
}

step4_network() {
    step_header 4 "Configure Libvirt Default Network"
    if ! sudo virsh net-info default &>/dev/null; then
        try_fix "define default network" \
            "sudo virsh net-define /usr/share/libvirt/networks/default.xml" "" "true"
    fi
    run_silent "start default network" sudo virsh net-start default
    run_silent "autostart default network" sudo virsh net-autostart default
    set_state 4; log "Libvirt default network ready"
}

step5_extract() {
    step_header 5 "Extract Fortinet KVM Images"
    sudo mkdir -p "$IMG_DIR"

    extract_image() {
        local label="$1" search_dir="$2" out_name="$3"
        local zip_file
        zip_file=$(find "$search_dir" -maxdepth 1 -name '*.zip' 2>/dev/null | head -1)
        if [[ -z "$zip_file" ]]; then
            warn "No $label zip found in $search_dir — skipping"
            return
        fi
        if [[ -f "$IMG_DIR/$out_name" ]]; then
            echo -e "  ${D}⊘${RST} $out_name already exists — skipping"
            return
        fi

        local tmp
        tmp=$(mktemp -d)
        start_spinner "Extracting $label..."
        unzip -o "$zip_file" -d "$tmp" >>"$LOG_FILE" 2>&1
        local rc=$?
        stop_spinner

        if (( rc != 0 )); then
            err "Failed to unzip $label"
            rm -rf "$tmp"
            return
        fi

        local qcow
        qcow=$(find "$tmp" -name '*.qcow2' | head -1)
        if [[ -n "$qcow" ]]; then
            start_spinner "Copying $label to $IMG_DIR..."
            sudo cp "$qcow" "$IMG_DIR/$out_name"
            stop_spinner
            echo -e "  ${G}✔${RST} $label → $out_name"
        else
            err "No qcow2 found inside $label zip"
        fi
        rm -rf "$tmp"
    }

    extract_image "FortiGate"      "$FORTINET_DIR/FortiGate"      "fortigate.qcow2"
    extract_image "FortiAnalyzer"   "$FORTINET_DIR/FortiAnalyser"   "fortianalyzer.qcow2"
    extract_image "FortiManager"    "$FORTINET_DIR/FortiManager"    "fortimanager.qcow2"

    if [[ ! -f "$IMG_DIR/faz-data.qcow2" ]]; then
        run_silent "create FAZ data disk ($FAZ_DATA_SIZE)" \
            sudo qemu-img create -f qcow2 "$IMG_DIR/faz-data.qcow2" "$FAZ_DATA_SIZE"
    fi
    if [[ ! -f "$IMG_DIR/fmg-data.qcow2" ]]; then
        run_silent "create FMG data disk ($FMG_DATA_SIZE)" \
            sudo qemu-img create -f qcow2 "$IMG_DIR/fmg-data.qcow2" "$FMG_DATA_SIZE"
    fi

    run_silent "fix image permissions" bash -c \
        "sudo chown libvirt-qemu:kvm $IMG_DIR/*.qcow2 && sudo chmod 660 $IMG_DIR/*.qcow2"

    set_state 5; log "Fortinet images extracted"
}

step6_deploy_vms() {
    step_header 6 "Deploy Fortinet VMs"

    deploy_vm() {
        local name="$1" ram="$2" cpu="$3"; shift 3
        local disk_args=()
        local first_disk="$1"
        for d in "$@"; do
            disk_args+=(--disk "path=$d,format=qcow2,bus=virtio")
        done

        if sudo virsh dominfo "$name" &>/dev/null; then
            echo -e "  ${D}⊘${RST} $name already exists — skipping"
            return
        fi
        if [[ ! -f "$first_disk" ]]; then
            err "$(basename "$first_disk") not found — cannot create $name"
            return
        fi

        countdown "Deploying $name"
        try_fix "create $name" \
            "sudo virt-install \
                --name $name \
                --ram $ram --vcpus $cpu \
                --cpu host-model --os-variant generic \
                --import \
                ${disk_args[*]} \
                --network network=$NETWORK,model=virtio \
                --graphics none --noautoconsole" \
            "sudo virsh destroy $name 2>/dev/null; sudo virsh undefine $name 2>/dev/null" \
            "true"
    }

    deploy_vm "FortiGate"      $FGT_RAM $FGT_CPU "$IMG_DIR/fortigate.qcow2"
    deploy_vm "FortiAnalyzer"   $FAZ_RAM $FAZ_CPU "$IMG_DIR/fortianalyzer.qcow2" "$IMG_DIR/faz-data.qcow2"
    deploy_vm "FortiManager"    $FMG_RAM $FMG_CPU "$IMG_DIR/fortimanager.qcow2"  "$IMG_DIR/fmg-data.qcow2"

    set_state 6; log "Fortinet VMs deployed"
}

step7_grub() {
    step_header 7 "GRUB — Detect Other OS (Windows)"

    if [[ -f /etc/default/grub ]]; then
        if ! grep -q "GRUB_DISABLE_OS_PROBER=false" /etc/default/grub; then
            warn "Enabling os-prober in GRUB..."
            echo 'GRUB_DISABLE_OS_PROBER=false' | sudo tee -a /etc/default/grub > /dev/null
        fi
    fi

    try_fix "os-prober" "sudo os-prober" "" "true"
    try_fix "update-grub" "sudo update-grub" "" "true"

    echo ""
    info "GRUB entries:"
    grep -oP "menuentry '\K[^']+" /boot/grub/grub.cfg 2>/dev/null | head -15 | while IFS= read -r entry; do
        echo -e "    ${B}▸${RST} $entry"
    done
    echo ""

    if grep -qi 'windows' /boot/grub/grub.cfg 2>/dev/null; then
        log "Windows detected in GRUB ✔"
    else
        warn "Windows NOT in GRUB. Try mounting the Windows EFI partition first."
        info "  sudo mount /dev/<win-efi> /mnt && sudo os-prober && sudo update-grub"
    fi

    set_state 7; log "GRUB updated"
}

step8_verify() {
    step_header 8 "Verify & Summary"
    echo ""

    start_spinner "Gathering VM info..."
    local vm_list
    vm_list=$(sudo virsh list --all 2>/dev/null)
    local dhcp_list
    dhcp_list=$(sudo virsh net-dhcp-leases default 2>/dev/null)
    local img_list
    img_list=$(sudo ls -lh "$IMG_DIR"/*.qcow2 2>/dev/null | awk '{printf "%-10s %s\n", $5, $NF}')
    local grub_list
    grub_list=$(grep -oP "menuentry '\K[^']+" /boot/grub/grub.cfg 2>/dev/null | head -10)
    stop_spinner

    echo -e "${W}  ┌─ VM Status ──────────────────────────────────────────────┐${RST}"
    while IFS= read -r l; do echo -e "  │ $l"; done <<< "$vm_list"
    echo -e "${W}  └──────────────────────────────────────────────────────────┘${RST}"
    echo ""
    echo -e "${W}  ┌─ DHCP Leases ────────────────────────────────────────────┐${RST}"
    while IFS= read -r l; do echo -e "  │ $l"; done <<< "$dhcp_list"
    echo -e "${W}  └──────────────────────────────────────────────────────────┘${RST}"
    echo ""
    echo -e "${W}  ┌─ Disk Images ────────────────────────────────────────────┐${RST}"
    while IFS= read -r l; do echo -e "  │ $l"; done <<< "$img_list"
    echo -e "${W}  └──────────────────────────────────────────────────────────┘${RST}"
    echo ""
    echo -e "${W}  ┌─ GRUB OS List ───────────────────────────────────────────┐${RST}"
    while IFS= read -r e; do echo -e "  │ ▸ $e"; done <<< "$grub_list"
    echo -e "${W}  └──────────────────────────────────────────────────────────┘${RST}"

    set_state 8; log "Setup fully verified"
    echo ""
    echo -e "${G}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RST}"
    echo -ne "  ${G}"
    typewrite "            ALL DONE — crafted by wolf" 0.04
    echo -ne "${RST}"
    echo -e "${G}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RST}"
}

# ── Step Registry ────────────────────────────────────────────────────────────
STEPS=(
    "1|APT Update|step1_update"
    "2|APT Full Upgrade|step2_upgrade"
    "3|Install KVM Stack|step3_install_kvm"
    "4|Configure Libvirt Network|step4_network"
    "5|Extract Fortinet Images|step5_extract"
    "6|Deploy Fortinet VMs|step6_deploy_vms"
    "7|GRUB OS Detection|step7_grub"
    "8|Verify & Summary|step8_verify"
)
TOTAL_STEPS=8

run_step() {
    local num="$1"
    for s in "${STEPS[@]}"; do
        IFS='|' read -r snum sname sfunc <<< "$s"
        [[ "$snum" == "$num" ]] && { $sfunc; return 0; }
    done
    err "Unknown step: $num"; return 1
}

# ── Parse ranges: "1-3", "5", "2-6,8", "1,3,7-8" ───────────────────────────
parse_steps() {
    local input="$1" result=()
    IFS=',' read -ra parts <<< "$input"
    for part in "${parts[@]}"; do
        part=$(echo "$part" | tr -d ' ')
        if [[ "$part" =~ ^([0-9]+)-([0-9]+)$ ]]; then
            for (( i=BASH_REMATCH[1]; i<=BASH_REMATCH[2]; i++ )); do
                (( i>=1 && i<=TOTAL_STEPS )) && result+=("$i")
            done
        elif [[ "$part" =~ ^[0-9]+$ ]]; then
            (( part>=1 && part<=TOTAL_STEPS )) && result+=("$part")
        fi
    done
    printf '%s\n' "${result[@]}" | sort -n -u
}

# ── Menu ─────────────────────────────────────────────────────────────────────
show_steps_list() {
    local current=$(get_state)
    echo ""
    for s in "${STEPS[@]}"; do
        IFS='|' read -r snum sname sfunc <<< "$s"
        if (( snum <= current )); then
            echo -e "    ${D}[$snum] $sname  ✔${RST}"
        else
            echo -e "    ${C}[$snum]${RST} $sname"
        fi
    done
    echo ""
}

show_menu() {
    local current=$(get_state)
    echo -e "${W}  Select Mode:${RST}"
    echo ""
    echo -e "    ${C}[1]${RST}  Auto-run all (resumes from step $((current + 1)))"
    echo -e "    ${C}[2]${RST}  Manual — pick steps  ${D}(e.g. 1-3  5,7-8  4)${RST}"
    echo -e "    ${C}[3]${RST}  Reset state & start fresh"
    echo -e "    ${C}[4]${RST}  Show progress"
    echo -e "    ${C}[0]${RST}  Quit"
    echo ""
    echo -ne "${Y}  ▸ Choice: ${RST}"
}

# ── Main ─────────────────────────────────────────────────────────────────────
main() {
    # Ensure cleanup on exit
    trap 'stop_spinner 2>/dev/null' EXIT INT TERM

    banner

    if [[ $EUID -ne 0 ]] && ! sudo -n true 2>/dev/null; then
        warn "This script needs sudo. You may be prompted for your password."
    fi

    local current=$(get_state)
    if (( current > 0 && current < TOTAL_STEPS )); then
        info "Resuming — last completed step: $current/$TOTAL_STEPS"
        progress_bar "$current" "$TOTAL_STEPS"
    elif (( current >= TOTAL_STEPS )); then
        log "All steps completed! Use [3] to reset or [2] to re-run steps."
    fi

    while true; do
        show_menu
        read -r choice
        case "$choice" in
            1)
                local start=$(( $(get_state) + 1 ))
                if (( start > TOTAL_STEPS )); then
                    warn "All steps done. Use [3] to reset."
                    continue
                fi
                for (( i=start; i<=TOTAL_STEPS; i++ )); do
                    run_step "$i"
                done
                break
                ;;
            2)
                while true; do
                    show_steps_list
                    echo -e "    ${D}Examples: 3  |  1-4  |  3-5,8  |  1,3,7-8${RST}"
                    echo ""
                    echo -ne "${Y}  ▸ Enter steps (or 0 to go back): ${RST}"
                    read -r input
                    [[ "$input" == "0" ]] && break

                    local run_list
                    run_list=$(parse_steps "$input")
                    if [[ -z "$run_list" ]]; then
                        err "No valid steps in: $input"
                        continue
                    fi

                    echo -e "\n${W}  Will run steps:${RST} $(echo $run_list | tr '\n' ' ')"
                    echo -ne "${Y}  ▸ Confirm? [Y/n]: ${RST}"
                    read -r confirm
                    [[ "${confirm,,}" == "n" ]] && continue

                    for s in $run_list; do
                        run_step "$s"
                    done
                done
                ;;
            3)
                rm -f "$STATE_FILE"
                log "State reset to 0"
                banner
                ;;
            4)
                show_steps_list
                progress_bar "$(get_state)" "$TOTAL_STEPS"
                ;;
            0)
                echo ""
                echo -ne "${D}  "
                typewrite "crafted by wolf — see you next boot." 0.03
                echo -e "${RST}"
                exit 0
                ;;
            *)
                err "Invalid choice"
                ;;
        esac
    done
}

main "$@"