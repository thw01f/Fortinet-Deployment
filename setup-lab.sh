#!/bin/bash
#==============================================================================
#  crafted by wolf
#==============================================================================

# ── Config ───────────────────────────────────────────────────────────────────
STATE_FILE="$HOME/.wolf_setup_state"
LOG_FILE="$HOME/.wolf_setup.log"
DEFAULT_FORTINET_DIR="$HOME/Documents/Fortinet"
FORTINET_DIR=""
IMG_DIR="/var/lib/libvirt/images"
NETWORK="default"
MAX_RETRIES=3

FGT_RAM=2048; FGT_CPU=1;  FGT_LOG_SIZE="30G"
FAZ_RAM=4096; FAZ_CPU=2;  FAZ_DATA_SIZE="200G"
FMG_RAM=4096; FMG_CPU=2;  FMG_DATA_SIZE="200G"

# ── Colors ───────────────────────────────────────────────────────────────────
R='\033[1;31m'; G='\033[1;32m'; Y='\033[1;33m'; C='\033[1;36m'; M='\033[1;35m'
B='\033[1;34m'; W='\033[1;37m'; D='\033[0;90m'; RST='\033[0m'

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
    echo -e "${M}               IST Cybersecurity Lab Setup ${RST}"
    echo -e "${D}                       crafted by wolf${RST}"
    echo -e "${D}──────────────────────────────────────────────────────────────────────${RST}"
    echo ""
}

# ── Animations ───────────────────────────────────────────────────────────────
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
    if [[ -n "$SPINNER_PID" ]] && kill -0 "$SPINNER_PID" 2>/dev/null; then
        kill "$SPINNER_PID" 2>/dev/null
        wait "$SPINNER_PID" 2>/dev/null
    fi
    SPINNER_PID=""
    printf "\r\033[K"
}

typewrite() {
    local text="$1" delay="${2:-0.02}"
    for (( i=0; i<${#text}; i++ )); do
        printf '%s' "${text:$i:1}"
        sleep "$delay"
    done
    echo ""
}

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

wolf_run() {
    local frames=(
        "  🐺        "  "    🐺      "  "      🐺    "
        "        🐺  "  "          🐺"  "        🐺  "
        "      🐺    "  "    🐺      "
    )
    for frame in "${frames[@]}"; do
        printf "\r${D}%s${RST}" "$frame"
        sleep 0.08
    done
    printf "\r\033[K"
}

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

# ── Permission fix ───────────────────────────────────────────────────────────
fix_permissions() {
    info "Fixing file permissions..."
    sudo mkdir -p "$IMG_DIR"
    sudo chmod 755 /var/lib/libvirt 2>/dev/null || true
    sudo chmod 755 "$IMG_DIR" 2>/dev/null || true

    # Guard: only chown/chmod if qcow2 files actually exist
    if compgen -G "$IMG_DIR/*.qcow2" > /dev/null 2>&1; then
        sudo chown libvirt-qemu:kvm "$IMG_DIR"/*.qcow2 2>/dev/null || true
        sudo chmod 660 "$IMG_DIR"/*.qcow2 2>/dev/null || true
    fi
    if compgen -G "$IMG_DIR/*.img" > /dev/null 2>&1; then
        sudo chown libvirt-qemu:kvm "$IMG_DIR"/*.img 2>/dev/null || true
        sudo chmod 660 "$IMG_DIR"/*.img 2>/dev/null || true
    fi

    if [[ -d "$FORTINET_DIR" ]]; then
        chmod -R u+rX "$FORTINET_DIR" 2>/dev/null || true
    fi

    local home_dir
    home_dir=$(eval echo "~")
    sudo chmod o+x "$home_dir" 2>/dev/null || true
    sudo chmod 666 /var/run/libvirt/libvirt-sock 2>/dev/null || true
    sudo usermod -aG libvirt "$(whoami)" 2>/dev/null || true
    sudo usermod -aG kvm "$(whoami)" 2>/dev/null || true
    log "Permissions fixed"
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

        if [[ -n "$fix_cmd" ]]; then
            start_spinner "Applying fix..."
            eval "$fix_cmd" >>"$LOG_FILE" 2>&1 || true
            stop_spinner
        fi

        local last_err
        last_err=$(tail -10 "$LOG_FILE" 2>/dev/null)

        if echo "$last_err" | grep -qi "dpkg.*lock\|Could not get lock"; then
            start_spinner "Fixing dpkg locks..."
            sudo rm -f /var/lib/dpkg/lock-frontend /var/lib/apt/lists/lock /var/cache/apt/archives/lock 2>/dev/null
            sudo dpkg --configure -a 2>/dev/null || true
            stop_spinner; warn "Cleared stale locks"
        fi
        if echo "$last_err" | grep -qi "dpkg was interrupted\|configure -a"; then
            start_spinner "Running dpkg --configure -a..."
            sudo dpkg --configure -a 2>/dev/null || true
            stop_spinner; warn "dpkg reconfigured"
        fi
        if echo "$last_err" | grep -qi "Broken\|unmet dependencies\|broken packages"; then
            start_spinner "Repairing broken packages..."
            sudo apt --fix-broken install -y 2>/dev/null || true
            stop_spinner; warn "Broken packages repaired"
        fi
        if echo "$last_err" | grep -qi "NO_PUBKEY\|GPG error\|not signed"; then
            start_spinner "Refreshing Kali keyring..."
            sudo apt install -y kali-archive-keyring 2>/dev/null || true
            stop_spinner; warn "Keyring refreshed"
        fi
        if echo "$last_err" | grep -qi "Temporary failure\|Could not resolve\|connection timed out"; then
            for (( w=10; w>0; w-- )); do
                printf "\r  ${Y}⏳${RST} ${D}Network error — retrying in %d...${RST}  " "$w"
                sleep 1
            done
            printf "\r\033[K"
            sudo systemctl restart NetworkManager 2>/dev/null || true; sleep 3
        fi
        if echo "$last_err" | grep -qi "libvirt\|virsh.*connect\|Failed to connect"; then
            start_spinner "Restarting libvirtd..."
            sudo systemctl restart libvirtd 2>/dev/null || true; sleep 3
            stop_spinner; warn "libvirtd restarted"
        fi
        if echo "$last_err" | grep -qi "Permission denied\|Cannot access storage\|could not open"; then
            start_spinner "Fixing permissions..."
            fix_permissions >>"$LOG_FILE" 2>&1
            stop_spinner; warn "Permissions repaired"
        fi

        ((attempt++)); sleep 2
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

# ── Path selection ───────────────────────────────────────────────────────────
select_fortinet_path() {
    echo -e "${W}  Fortinet Image Source:${RST}"
    echo ""
    echo -e "    ${C}[1]${RST}  Default: ${D}$DEFAULT_FORTINET_DIR${RST}"
    echo -e "    ${C}[2]${RST}  Custom path"
    echo ""
    echo -ne "${Y}  ▸ Choice: ${RST}"
    read -r pchoice

    case "$pchoice" in
        2)
            echo -ne "${Y}  ▸ Enter full path to Fortinet folder: ${RST}"
            read -r custom_path
            custom_path="${custom_path/#\~/$HOME}"
            if [[ ! -d "$custom_path" ]]; then
                err "Directory not found: $custom_path"
                echo -ne "${Y}  ▸ Create it? [Y/n]: ${RST}"
                read -r mk
                if [[ "${mk,,}" != "n" ]]; then
                    mkdir -p "$custom_path"; log "Created: $custom_path"
                else
                    warn "Falling back to default"
                    custom_path="$DEFAULT_FORTINET_DIR"
                fi
            fi
            FORTINET_DIR="$custom_path"
            ;;
        *) FORTINET_DIR="$DEFAULT_FORTINET_DIR" ;;
    esac

    echo ""
    info "Using: $FORTINET_DIR"
    echo ""

    echo -e "${W}  Checking directory structure:${RST}"
    local valid=true

    for pair in "FortiGate:FortiGate" "FortiAnalyser:FortiAnalyzer" "FortiManager:FortiManager"; do
        local dir="${pair%%:*}" label="${pair##*:}"
        if [[ -d "$FORTINET_DIR/$dir" ]]; then
            local z=$(find "$FORTINET_DIR/$dir" -maxdepth 1 -name '*.zip' 2>/dev/null | head -1)
            if [[ -n "$z" ]]; then
                echo -e "    ${G}✔${RST} $label — $(basename "$z")"
            else
                echo -e "    ${Y}!${RST} $label — no .zip found"; valid=false
            fi
        else
            echo -e "    ${R}✖${RST} $label — folder missing"; valid=false
        fi
    done

    echo ""
    [[ "$valid" == "false" ]] && warn "Some images missing — affected steps will be skipped"
    [[ "$valid" == "true" ]] && log "All Fortinet images found"

    echo "$FORTINET_DIR" > "$HOME/.wolf_fortinet_path"
}

load_fortinet_path() {
    if [[ -f "$HOME/.wolf_fortinet_path" ]]; then
        FORTINET_DIR=$(cat "$HOME/.wolf_fortinet_path")
        info "Using saved path: $FORTINET_DIR"
    else
        FORTINET_DIR="$DEFAULT_FORTINET_DIR"
    fi
}

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
        "sudo DEBIAN_FRONTEND=noninteractive apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager virtinst unzip cpu-checker os-prober expect" \
        "sudo apt --fix-broken install -y"
    try_fix "enable libvirtd" \
        "sudo systemctl enable --now libvirtd" "" "true"
    fix_permissions
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
    [[ -z "$FORTINET_DIR" ]] && load_fortinet_path

    extract_image() {
        local label="$1" search_dir="$2" out_name="$3"
        local zip_file
        zip_file=$(find "$search_dir" -maxdepth 1 -name '*.zip' 2>/dev/null | head -1)
        if [[ -z "$zip_file" ]]; then
            warn "No $label zip found in $search_dir — skipping"; return
        fi
        if [[ -f "$IMG_DIR/$out_name" ]]; then
            echo -e "  ${D}⊘${RST} $out_name already exists — skipping"; return
        fi
        local tmp; tmp=$(mktemp -d)
        start_spinner "Extracting $label..."
        unzip -o "$zip_file" -d "$tmp" >>"$LOG_FILE" 2>&1
        local rc=$?; stop_spinner
        if (( rc != 0 )); then err "Failed to unzip $label"; rm -rf "$tmp"; return; fi
        local qcow; qcow=$(find "$tmp" -name '*.qcow2' | head -1)
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

    # Create data/log disks
    if [[ ! -f "$IMG_DIR/fgt-log.qcow2" ]]; then
        run_silent "create FortiGate log disk ($FGT_LOG_SIZE)" \
            sudo qemu-img create -f qcow2 "$IMG_DIR/fgt-log.qcow2" "$FGT_LOG_SIZE"
    fi
    if [[ ! -f "$IMG_DIR/faz-data.qcow2" ]]; then
        run_silent "create FortiAnalyzer data disk ($FAZ_DATA_SIZE)" \
            sudo qemu-img create -f qcow2 "$IMG_DIR/faz-data.qcow2" "$FAZ_DATA_SIZE"
    fi
    if [[ ! -f "$IMG_DIR/fmg-data.qcow2" ]]; then
        run_silent "create FortiManager data disk ($FMG_DATA_SIZE)" \
            sudo qemu-img create -f qcow2 "$IMG_DIR/fmg-data.qcow2" "$FMG_DATA_SIZE"
    fi

    fix_permissions
    set_state 5; log "Fortinet images extracted"
}

step6_deploy_vms() {
    step_header 6 "Deploy Fortinet VMs"
    fix_permissions

    deploy_vm() {
        local name="$1" ram="$2" cpu="$3"; shift 3
        local disk_args=()
        local first_disk="$1"
        for d in "$@"; do
            disk_args+=(--disk "path=$d,format=qcow2,bus=virtio")
        done

        if sudo virsh dominfo "$name" &>/dev/null; then
            echo -e "  ${D}⊘${RST} $name already exists — skipping"; return
        fi
        if [[ ! -f "$first_disk" ]]; then
            err "$(basename "$first_disk") not found — cannot create $name"; return
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

    # FortiGate: system disk + 30GB log disk
    deploy_vm "FortiGate" $FGT_RAM $FGT_CPU \
        "$IMG_DIR/fortigate.qcow2" "$IMG_DIR/fgt-log.qcow2"

    # FortiAnalyzer: system disk + 200GB data disk
    deploy_vm "FortiAnalyzer" $FAZ_RAM $FAZ_CPU \
        "$IMG_DIR/fortianalyzer.qcow2" "$IMG_DIR/faz-data.qcow2"

    # FortiManager: system disk + 200GB data disk
    deploy_vm "FortiManager" $FMG_RAM $FMG_CPU \
        "$IMG_DIR/fortimanager.qcow2" "$IMG_DIR/fmg-data.qcow2"

    set_state 6; log "Fortinet VMs deployed"
}

step7_init_disks() {
    step_header 7 "Initialize VM Disks (LVM Format)"

    # Check if expect is available
    if ! command -v expect &>/dev/null; then
        warn "expect not installed — installing..."
        sudo apt install -y expect >>"$LOG_FILE" 2>&1
    fi

    init_fortinet_lvm() {
        local vm_name="$1"
        local wait_time="${2:-90}"

        if ! sudo virsh dominfo "$vm_name" &>/dev/null; then
            warn "$vm_name does not exist — skipping"; return
        fi

        # Ensure VM is running
        local state
        state=$(sudo virsh domstate "$vm_name" 2>/dev/null | tr -d '[:space:]')
        if [[ "$state" != "running" ]]; then
            info "Starting $vm_name..."
            sudo virsh start "$vm_name" 2>/dev/null || true
        fi

        # Wait for VM to boot
        info "Waiting ${wait_time}s for $vm_name to boot..."
        local elapsed=0
        while (( elapsed < wait_time )); do
            printf "\r  ${C}⏳${RST} ${D}$vm_name booting... %d/%ds${RST}  " "$elapsed" "$wait_time"
            sleep 5
            ((elapsed+=5))

            # Try to detect if VM is ready by checking console output
            local console_check
            console_check=$(echo "" | sudo timeout 3 virsh console "$vm_name" 2>/dev/null | head -5 || true)
            if echo "$console_check" | grep -qi "login\|#\|FortiAnalyzer\|FortiManager\|FortiGate"; then
                printf "\r\033[K"
                info "$vm_name is ready!"
                break
            fi
        done
        printf "\r\033[K"

        # Send LVM commands via expect
        info "Sending LVM commands to $vm_name..."
        sudo expect <<EXPECT_EOF >>"$LOG_FILE" 2>&1
set timeout 30
spawn virsh console $vm_name

# Wait for console prompt
expect {
    "login:" {
        send "admin\r"
        expect {
            "Password:" { send "\r" }
            "#" { }
            "$ " { }
        }
    }
    "#" { }
    "$ " { }
    timeout {
        send "\r"
        expect {
            "login:" {
                send "admin\r"
                expect {
                    "Password:" { send "\r" }
                    "#" { }
                }
            }
            "#" { }
            "$ " { }
        }
    }
}

# Wait for prompt
sleep 2
send "\r"
expect -re {[#$] }

# Execute LVM commands
send "execute lvm start\r"
expect -re {[#$] }
sleep 3

send "execute lvm extend\r"
expect {
    "Do you want to continue" {
        send "y\r"
        expect -re {[#$] }
    }
    -re {[#$] } { }
    timeout { }
}

sleep 2
send "\r"
expect -re {[#$] }

# Disconnect cleanly (Ctrl+] to exit virsh console)
send "\x1d"
sleep 1
EXPECT_EOF

        local rc=$?
        if (( rc == 0 )); then
            echo -e "  ${G}✔${RST} $vm_name LVM initialized"
        else
            warn "$vm_name LVM init may need manual steps"
            info "  Manual: sudo virsh console $vm_name"
            info "  Login:  admin / (no password)"
            info "  Run:    execute lvm start"
            info "  Run:    execute lvm extend"
        fi
    }

    echo ""
    info "This step boots each VM and runs 'execute lvm start/extend'"
    info "to format and activate the data/log disks inside FortiOS."
    echo ""

    init_fortinet_lvm "FortiGate" 60
    init_fortinet_lvm "FortiAnalyzer" 90
    init_fortinet_lvm "FortiManager" 90

    echo ""
    info "If auto-init didn't work, run manually per VM:"
    echo -e "    ${D}sudo virsh console <VM_Name>${RST}"
    echo -e "    ${D}Login: admin / (no password)${RST}"
    echo -e "    ${D}# execute lvm start${RST}"
    echo -e "    ${D}# execute lvm extend${RST}"
    echo ""

    set_state 7; log "VM disk initialization attempted"
}

step8_grub() {
    step_header 8 "GRUB — Windows Default + 5s Timeout"

    local grub_file="/etc/default/grub"

    if [[ ! -f "$grub_file" ]]; then
        err "GRUB config not found at $grub_file"
        set_state 8; return
    fi

    # ── Fix GRUB_DISABLE_OS_PROBER (replace, not append) ──
    if grep -q "^GRUB_DISABLE_OS_PROBER" "$grub_file"; then
        sudo sed -i 's/^GRUB_DISABLE_OS_PROBER=.*/GRUB_DISABLE_OS_PROBER=false/' "$grub_file"
        log "Set GRUB_DISABLE_OS_PROBER=false (replaced existing)"
    elif grep -q "^#.*GRUB_DISABLE_OS_PROBER" "$grub_file"; then
        sudo sed -i 's/^#.*GRUB_DISABLE_OS_PROBER=.*/GRUB_DISABLE_OS_PROBER=false/' "$grub_file"
        log "Uncommented and set GRUB_DISABLE_OS_PROBER=false"
    else
        echo 'GRUB_DISABLE_OS_PROBER=false' | sudo tee -a "$grub_file" > /dev/null
        log "Added GRUB_DISABLE_OS_PROBER=false"
    fi

    # ── Set timeout to 5 seconds ──
    if grep -q "^GRUB_TIMEOUT=" "$grub_file"; then
        sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=5/' "$grub_file"
    else
        echo 'GRUB_TIMEOUT=5' | sudo tee -a "$grub_file" > /dev/null
    fi
    log "GRUB timeout set to 5 seconds"

    # Remove hidden timeout (often hides the menu)
    sudo sed -i 's/^GRUB_TIMEOUT_STYLE=hidden/GRUB_TIMEOUT_STYLE=menu/' "$grub_file" 2>/dev/null
    if ! grep -q "^GRUB_TIMEOUT_STYLE" "$grub_file"; then
        echo 'GRUB_TIMEOUT_STYLE=menu' | sudo tee -a "$grub_file" > /dev/null
    fi

    # ── Run os-prober and update-grub ──
    try_fix "os-prober" "sudo os-prober" "" "true"
    try_fix "update-grub" "sudo update-grub" "" "true"

    # ── Find Windows entry and set as default ──
    echo ""
    info "Detecting Windows in GRUB..."

    # Parse grub.cfg to find Windows menuentry ID
    local win_entry=""

    # Method 1: Look for exact submenu>entry path
    # grub.cfg uses nested menuentry inside submenu, need the full path
    local win_id
    win_id=$(awk '
        /^menuentry / { main_idx++; sub_idx=0 }
        /^submenu / { submenu_start=main_idx; in_submenu=1; sub_idx=0 }
        /^\tmenuentry / && in_submenu {
            if (tolower($0) ~ /windows/) {
                # GRUB counts: main entries + submenu as one, then submenu entries by ID
                # We need "X>Y" format
                printf "%d>%d", submenu_start, sub_idx
                exit
            }
            sub_idx++
        }
        /^}/ && in_submenu { in_submenu=0 }
    ' /boot/grub/grub.cfg 2>/dev/null)

    # Method 2: simpler — look for Windows in top-level menuentries
    if [[ -z "$win_id" ]]; then
        local idx=0
        while IFS= read -r line; do
            if echo "$line" | grep -qi "windows"; then
                win_id="$idx"
                break
            fi
            ((idx++))
        done < <(grep -E "^menuentry |^submenu " /boot/grub/grub.cfg 2>/dev/null)
    fi

    # Method 3: use the string ID
    if [[ -z "$win_id" ]]; then
        win_id=$(grep -oP "menuentry '\K[^']*[Ww]indows[^']*" /boot/grub/grub.cfg 2>/dev/null | head -1)
        if [[ -n "$win_id" ]]; then
            win_id="\"$win_id\""
        fi
    fi

    if [[ -n "$win_id" ]]; then
        # Set GRUB_DEFAULT to saved, then set default via grub-set-default
        sudo sed -i 's/^GRUB_DEFAULT=.*/GRUB_DEFAULT=saved/' "$grub_file"
        if ! grep -q "^GRUB_DEFAULT=" "$grub_file"; then
            echo 'GRUB_DEFAULT=saved' | sudo tee -a "$grub_file" > /dev/null
        fi

        # Also ensure GRUB_SAVEDEFAULT is set
        if grep -q "^GRUB_SAVEDEFAULT=" "$grub_file"; then
            sudo sed -i 's/^GRUB_SAVEDEFAULT=.*/GRUB_SAVEDEFAULT=true/' "$grub_file"
        else
            echo 'GRUB_SAVEDEFAULT=true' | sudo tee -a "$grub_file" > /dev/null
        fi

        sudo grub-set-default "$win_id" 2>>"$LOG_FILE"
        log "Windows set as default boot: $win_id"

        # Re-run update-grub with all changes
        try_fix "update-grub (final)" "sudo update-grub" "" "true"
    else
        warn "Windows entry not found in GRUB — cannot set as default"
        info "You may need to manually run: sudo grub-set-default <entry_number>"
    fi

    # ── Show final GRUB entries ──
    echo ""
    info "GRUB entries:"
    local idx=0
    while IFS= read -r entry; do
        echo -e "    ${B}[$idx]${RST} $entry"
        ((idx++))
    done < <(grep -oP "menuentry '\K[^']+" /boot/grub/grub.cfg 2>/dev/null | head -15)

    echo ""
    if grep -qi 'windows' /boot/grub/grub.cfg 2>/dev/null; then
        log "Windows detected in GRUB ✔"
    else
        warn "Windows NOT in GRUB. Try: sudo mount /dev/<win-efi> /mnt && sudo os-prober && sudo update-grub"
    fi

    set_state 8; log "GRUB updated — Windows default, 5s timeout"
}

step9_verify() {
    step_header 9 "Verify & Summary"
    echo ""

    start_spinner "Gathering info..."
    local vm_list dhcp_list img_list grub_list grub_default grub_timeout
    vm_list=$(sudo virsh list --all 2>/dev/null)
    dhcp_list=$(sudo virsh net-dhcp-leases default 2>/dev/null)
    img_list=$(sudo ls -lh "$IMG_DIR"/*.qcow2 2>/dev/null | awk '{printf "%-10s %s\n", $5, $NF}')
    grub_list=$(grep -oP "menuentry '\K[^']+" /boot/grub/grub.cfg 2>/dev/null | head -10)
    grub_default=$(grep "^GRUB_DEFAULT=" /etc/default/grub 2>/dev/null)
    grub_timeout=$(grep "^GRUB_TIMEOUT=" /etc/default/grub 2>/dev/null)
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
    echo -e "${W}  ┌─ GRUB Config ───────────────────────────────────────────┐${RST}"
    echo -e "  │ $grub_default"
    echo -e "  │ $grub_timeout"
    while IFS= read -r e; do echo -e "  │ ▸ $e"; done <<< "$grub_list"
    echo -e "${W}  └──────────────────────────────────────────────────────────┘${RST}"
    echo ""
    echo -e "  ${D}Fortinet path: $FORTINET_DIR${RST}"

    set_state 9; log "Setup fully verified"
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
    "7|Initialize VM Disks (LVM)|step7_init_disks"
    "8|GRUB — Windows Default|step8_grub"
    "9|Verify & Summary|step9_verify"
)
TOTAL_STEPS=9

run_step() {
    local num="$1"
    for s in "${STEPS[@]}"; do
        IFS='|' read -r snum sname sfunc <<< "$s"
        [[ "$snum" == "$num" ]] && { $sfunc; return 0; }
    done
    err "Unknown step: $num"; return 1
}

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
    echo -e "    ${C}[2]${RST}  Manual — pick steps  ${D}(e.g. 1-3  5,7-9  4)${RST}"
    echo -e "    ${C}[3]${RST}  Reset state & start fresh"
    echo -e "    ${C}[4]${RST}  Show progress"
    echo -e "    ${C}[5]${RST}  Change Fortinet path  ${D}(current: $FORTINET_DIR)${RST}"
    echo -e "    ${C}[0]${RST}  Quit"
    echo ""
    echo -ne "${Y}  ▸ Choice: ${RST}"
}

# ── Main ─────────────────────────────────────────────────────────────────────
main() {
    trap 'stop_spinner 2>/dev/null' EXIT INT TERM
    banner

    if [[ $EUID -ne 0 ]] && ! sudo -n true 2>/dev/null; then
        warn "This script needs sudo. You may be prompted for your password."
    fi

    if [[ -f "$HOME/.wolf_fortinet_path" ]]; then
        load_fortinet_path
    else
        select_fortinet_path
    fi

    start_spinner "Running default permission fixes..."
    fix_permissions >>"$LOG_FILE" 2>&1
    stop_spinner
    echo -e "  ${G}✔${RST} Permissions checked"
    echo ""

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
                    warn "All steps done. Use [3] to reset."; continue
                fi
                for (( i=start; i<=TOTAL_STEPS; i++ )); do run_step "$i"; done
                break
                ;;
            2)
                while true; do
                    show_steps_list
                    echo -e "    ${D}Examples: 3  |  1-4  |  3-5,8  |  1,3,7-9${RST}"
                    echo ""
                    echo -ne "${Y}  ▸ Enter steps (or 0 to go back): ${RST}"
                    read -r input
                    [[ "$input" == "0" ]] && break
                    local run_list; run_list=$(parse_steps "$input")
                    if [[ -z "$run_list" ]]; then err "No valid steps in: $input"; continue; fi
                    echo -e "\n${W}  Will run steps:${RST} $(echo $run_list | tr '\n' ' ')"
                    echo -ne "${Y}  ▸ Confirm? [Y/n]: ${RST}"
                    read -r confirm
                    [[ "${confirm,,}" == "n" ]] && continue
                    for s in $run_list; do run_step "$s"; done
                done
                ;;
            3)
                rm -f "$STATE_FILE" "$HOME/.wolf_fortinet_path"
                log "State and path reset"; banner; select_fortinet_path
                ;;
            4) show_steps_list; progress_bar "$(get_state)" "$TOTAL_STEPS" ;;
            5) select_fortinet_path ;;
            0)
                echo ""; echo -ne "${D}  "
                typewrite "crafted by wolf — see you next boot." 0.03
                echo -e "${RST}"; exit 0
                ;;
            *) err "Invalid choice" ;;
        esac
    done
}

main "$@"
