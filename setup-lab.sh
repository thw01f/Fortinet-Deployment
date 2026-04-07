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
    ( local i=0; while true; do
        printf "\r  ${C}${SPINNER_FRAMES[$((i % ${#SPINNER_FRAMES[@]}))]}${RST} ${D}%s${RST}  " "$msg"
        sleep 0.1; ((i++))
    done ) &
    SPINNER_PID=$!; disown $SPINNER_PID 2>/dev/null
}
stop_spinner() {
    if [[ -n "$SPINNER_PID" ]] && kill -0 "$SPINNER_PID" 2>/dev/null; then
        kill "$SPINNER_PID" 2>/dev/null; wait "$SPINNER_PID" 2>/dev/null
    fi; SPINNER_PID=""; printf "\r\033[K"
}
typewrite() {
    local text="$1" delay="${2:-0.02}"
    for (( i=0; i<${#text}; i++ )); do printf '%s' "${text:$i:1}"; sleep "$delay"; done; echo ""
}
progress_bar() {
    local current="$1" total="$2" width=40
    local filled=$(( current * width / total )) empty=$(( width - filled ))
    local pct=$(( current * 100 / total )) bar=""
    for (( i=0; i<filled; i++ )); do bar+="█"; done
    for (( i=0; i<empty; i++ )); do bar+="░"; done
    echo -e "  ${C}[$bar]${RST} ${W}${pct}%${RST}  ${D}(${current}/${total})${RST}"
}
wolf_run() {
    local frames=("  🐺        " "    🐺      " "      🐺    " "        🐺  "
                   "          🐺" "        🐺  " "      🐺    " "    🐺      ")
    for f in "${frames[@]}"; do printf "\r${D}%s${RST}" "$f"; sleep 0.08; done; printf "\r\033[K"
}
countdown() {
    local msg="$1" secs="${2:-3}"
    for (( i=secs; i>0; i-- )); do
        printf "\r  ${Y}⏳${RST} ${D}%s in %d...${RST}  " "$msg" "$i"; sleep 1
    done; printf "\r\033[K"
}

# ── Logging ──────────────────────────────────────────────────────────────────
log()  { echo -e "${G}[✔]${RST} $1"; echo "[$(date '+%H:%M:%S')] OK: $1" >> "$LOG_FILE"; }
warn() { echo -e "${Y}[!]${RST} $1"; echo "[$(date '+%H:%M:%S')] WARN: $1" >> "$LOG_FILE"; }
err()  { echo -e "${R}[✖]${RST} $1"; echo "[$(date '+%H:%M:%S')] ERR: $1" >> "$LOG_FILE"; }
info() { echo -e "${C}[i]${RST} $1"; }

step_header() {
    local done_count; done_count=$(get_done_count)
    echo ""; wolf_run
    echo -e "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RST}"
    echo -ne "  ${W}"; typewrite "STEP $1 ▸ $2" 0.03; echo -ne "${RST}"
    echo -e "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RST}"
    progress_bar "$done_count" "$TOTAL_STEPS"
}

run_silent() {
    local desc="$1"; shift; start_spinner "$desc"
    "$@" >>"$LOG_FILE" 2>&1; local rc=$?; stop_spinner
    (( rc == 0 )) && echo -e "  ${G}✔${RST} $desc" || echo -e "  ${R}✖${RST} $desc"
    return $rc
}

# ── Per-step state tracking ──────────────────────────────────────────────────
# State file stores comma-separated completed step numbers: "1,2,3,5"
is_step_done() {
    [[ -f "$STATE_FILE" ]] && grep -qw "$1" "$STATE_FILE"
}
mark_step_done() {
    if [[ -f "$STATE_FILE" ]]; then
        if ! grep -qw "$1" "$STATE_FILE"; then
            local current; current=$(cat "$STATE_FILE")
            if [[ -z "$current" ]]; then
                echo "$1" > "$STATE_FILE"
            else
                echo "${current},$1" > "$STATE_FILE"
            fi
        fi
    else
        echo "$1" > "$STATE_FILE"
    fi
}
get_done_count() {
    if [[ -f "$STATE_FILE" ]] && [[ -s "$STATE_FILE" ]]; then
        tr ',' '\n' < "$STATE_FILE" | sort -u | wc -l | tr -d ' '
    else
        echo "0"
    fi
}
get_done_list() {
    [[ -f "$STATE_FILE" ]] && cat "$STATE_FILE" || echo ""
}
get_next_undone() {
    for (( i=1; i<=TOTAL_STEPS; i++ )); do
        is_step_done "$i" || { echo "$i"; return; }
    done
    echo "done"
}
reset_state() {
    rm -f "$STATE_FILE" "$HOME/.wolf_fortinet_path"
}

# ── Permission fix ───────────────────────────────────────────────────────────
fix_permissions() {
    info "Fixing file permissions..."
    sudo mkdir -p "$IMG_DIR"
    sudo chmod 755 /var/lib/libvirt 2>/dev/null || true
    sudo chmod 755 "$IMG_DIR" 2>/dev/null || true
    if compgen -G "$IMG_DIR/*.qcow2" > /dev/null 2>&1; then
        sudo chown libvirt-qemu:kvm "$IMG_DIR"/*.qcow2 2>/dev/null || true
        sudo chmod 660 "$IMG_DIR"/*.qcow2 2>/dev/null || true
    fi
    if compgen -G "$IMG_DIR/*.img" > /dev/null 2>&1; then
        sudo chown libvirt-qemu:kvm "$IMG_DIR"/*.img 2>/dev/null || true
        sudo chmod 660 "$IMG_DIR"/*.img 2>/dev/null || true
    fi
    [[ -d "$FORTINET_DIR" ]] && chmod -R u+rX "$FORTINET_DIR" 2>/dev/null || true
    sudo chmod o+x "$(eval echo ~)" 2>/dev/null || true
    sudo chmod 666 /var/run/libvirt/libvirt-sock 2>/dev/null || true
    sudo usermod -aG libvirt "$(whoami)" 2>/dev/null || true
    sudo usermod -aG kvm "$(whoami)" 2>/dev/null || true
    log "Permissions fixed"
}

# ── Error handler ────────────────────────────────────────────────────────────
try_fix() {
    local desc="$1" cmd="$2" fix_cmd="${3:-}" silent="${4:-false}" attempt=1
    while (( attempt <= MAX_RETRIES )); do
        info "Attempt $attempt/$MAX_RETRIES: $desc"
        if [[ "$silent" == "true" ]]; then
            start_spinner "$desc"; eval "$cmd" >>"$LOG_FILE" 2>&1; local rc=$?; stop_spinner
            if (( rc == 0 )); then echo -e "  ${G}✔${RST} $desc"; return 0; fi
        else
            if eval "$cmd" 2>>"$LOG_FILE"; then return 0; fi
        fi
        err "Failed: $desc (attempt $attempt)"
        [[ -n "$fix_cmd" ]] && { start_spinner "Applying fix..."; eval "$fix_cmd" >>"$LOG_FILE" 2>&1 || true; stop_spinner; }
        local last_err; last_err=$(tail -10 "$LOG_FILE" 2>/dev/null)
        echo "$last_err" | grep -qi "dpkg.*lock\|Could not get lock" && {
            start_spinner "Fixing dpkg locks..."; sudo rm -f /var/lib/dpkg/lock-frontend /var/lib/apt/lists/lock /var/cache/apt/archives/lock 2>/dev/null
            sudo dpkg --configure -a 2>/dev/null || true; stop_spinner; warn "Cleared locks"; }
        echo "$last_err" | grep -qi "dpkg was interrupted\|configure -a" && {
            start_spinner "dpkg --configure -a..."; sudo dpkg --configure -a 2>/dev/null || true; stop_spinner; }
        echo "$last_err" | grep -qi "Broken\|unmet dependencies\|broken packages" && {
            start_spinner "Fixing broken packages..."; sudo apt --fix-broken install -y 2>/dev/null || true; stop_spinner; }
        echo "$last_err" | grep -qi "NO_PUBKEY\|GPG error\|not signed" && {
            start_spinner "Refreshing keyring..."; sudo apt install -y kali-archive-keyring 2>/dev/null || true; stop_spinner; }
        echo "$last_err" | grep -qi "Temporary failure\|Could not resolve\|connection timed out" && {
            for (( w=10; w>0; w-- )); do printf "\r  ${Y}⏳${RST} ${D}Network — retrying in %d...${RST}  " "$w"; sleep 1; done
            printf "\r\033[K"; sudo systemctl restart NetworkManager 2>/dev/null || true; sleep 3; }
        echo "$last_err" | grep -qi "libvirt\|virsh.*connect\|Failed to connect" && {
            start_spinner "Restarting libvirtd..."; sudo systemctl restart libvirtd 2>/dev/null || true; sleep 3; stop_spinner; }
        echo "$last_err" | grep -qi "Permission denied\|Cannot access storage\|could not open" && {
            start_spinner "Fixing permissions..."; fix_permissions >>"$LOG_FILE" 2>&1; stop_spinner; }
        ((attempt++)); sleep 2
    done
    err "FAILED after $MAX_RETRIES attempts: $desc"
    echo -ne "${Y}  ▸ Skip and continue? [Y/n]: ${RST}"; read -r ans
    [[ "${ans,,}" != "n" ]] && return 0
    echo -e "${R}  Aborting.${RST}"; exit 1
}

# ── Path selection ───────────────────────────────────────────────────────────
select_fortinet_path() {
    echo -e "${W}  Fortinet Image Source:${RST}"
    echo -e "\n    ${C}[1]${RST}  Default: ${D}$DEFAULT_FORTINET_DIR${RST}"
    echo -e "    ${C}[2]${RST}  Custom path\n"
    echo -ne "${Y}  ▸ Choice: ${RST}"; read -r pchoice
    case "$pchoice" in
        2)  echo -ne "${Y}  ▸ Enter full path: ${RST}"; read -r custom_path
            custom_path="${custom_path/#\~/$HOME}"
            if [[ ! -d "$custom_path" ]]; then
                err "Not found: $custom_path"; echo -ne "${Y}  ▸ Create? [Y/n]: ${RST}"; read -r mk
                [[ "${mk,,}" != "n" ]] && { mkdir -p "$custom_path"; log "Created: $custom_path"; } || custom_path="$DEFAULT_FORTINET_DIR"
            fi; FORTINET_DIR="$custom_path" ;;
        *)  FORTINET_DIR="$DEFAULT_FORTINET_DIR" ;;
    esac
    echo ""; info "Using: $FORTINET_DIR"; echo ""
    echo -e "${W}  Checking structure:${RST}"
    for pair in "FortiGate:FortiGate" "FortiAnalyser:FortiAnalyzer" "FortiManager:FortiManager"; do
        local dir="${pair%%:*}" label="${pair##*:}"
        if [[ -d "$FORTINET_DIR/$dir" ]]; then
            local z=$(find "$FORTINET_DIR/$dir" -maxdepth 1 -name '*.zip' 2>/dev/null | head -1)
            [[ -n "$z" ]] && echo -e "    ${G}✔${RST} $label — $(basename "$z")" || echo -e "    ${Y}!${RST} $label — no .zip"
        else echo -e "    ${R}✖${RST} $label — folder missing"; fi
    done; echo ""
    echo "$FORTINET_DIR" > "$HOME/.wolf_fortinet_path"
}
load_fortinet_path() {
    [[ -f "$HOME/.wolf_fortinet_path" ]] && { FORTINET_DIR=$(cat "$HOME/.wolf_fortinet_path"); info "Using saved path: $FORTINET_DIR"; } || FORTINET_DIR="$DEFAULT_FORTINET_DIR"
}

# ══════════════════════════════════════════════════════════════════════════════
#  STEPS
# ══════════════════════════════════════════════════════════════════════════════

step1_update() {
    step_header 1 "APT Update"
    try_fix "apt update" "sudo apt update -y" "sudo apt clean && sudo rm -rf /var/lib/apt/lists/* && sudo apt update -y"
    mark_step_done 1; log "APT update complete"
}

step2_upgrade() {
    step_header 2 "APT Full Upgrade"
    countdown "Starting full upgrade"
    try_fix "apt full-upgrade" "sudo DEBIAN_FRONTEND=noninteractive apt full-upgrade -y"
    mark_step_done 2; log "APT upgrade complete"
}

step3_install_kvm() {
    step_header 3 "Install KVM / Libvirt / Virt-Manager"
    try_fix "install KVM stack" \
        "sudo DEBIAN_FRONTEND=noninteractive apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager virtinst unzip cpu-checker os-prober expect" \
        "sudo apt --fix-broken install -y"
    try_fix "enable libvirtd" "sudo systemctl enable --now libvirtd" "" "true"
    fix_permissions
    mark_step_done 3; log "KVM stack installed"
}

step4_network() {
    step_header 4 "Configure Libvirt Default Network"
    sudo virsh net-info default &>/dev/null || try_fix "define default network" "sudo virsh net-define /usr/share/libvirt/networks/default.xml" "" "true"
    run_silent "start default network" sudo virsh net-start default
    run_silent "autostart default network" sudo virsh net-autostart default
    mark_step_done 4; log "Libvirt default network ready"
}

step5_extract() {
    step_header 5 "Extract Fortinet KVM Images"
    sudo mkdir -p "$IMG_DIR"
    [[ -z "$FORTINET_DIR" ]] && load_fortinet_path

    extract_image() {
        local label="$1" search_dir="$2" out_name="$3"
        local zip_file; zip_file=$(find "$search_dir" -maxdepth 1 -name '*.zip' 2>/dev/null | head -1)
        [[ -z "$zip_file" ]] && { warn "No $label zip in $search_dir — skipping"; return; }
        [[ -f "$IMG_DIR/$out_name" ]] && { echo -e "  ${D}⊘${RST} $out_name exists — skipping"; return; }
        local tmp; tmp=$(mktemp -d)
        start_spinner "Extracting $label..."; unzip -o "$zip_file" -d "$tmp" >>"$LOG_FILE" 2>&1; local rc=$?; stop_spinner
        (( rc != 0 )) && { err "Failed to unzip $label"; rm -rf "$tmp"; return; }
        local qcow; qcow=$(find "$tmp" -name '*.qcow2' | head -1)
        [[ -n "$qcow" ]] && { start_spinner "Copying $label..."; sudo cp "$qcow" "$IMG_DIR/$out_name"; stop_spinner; echo -e "  ${G}✔${RST} $label → $out_name"; } || err "No qcow2 in $label zip"
        rm -rf "$tmp"
    }

    extract_image "FortiGate"     "$FORTINET_DIR/FortiGate"     "fortigate.qcow2"
    extract_image "FortiAnalyzer"  "$FORTINET_DIR/FortiAnalyser"  "fortianalyzer.qcow2"
    extract_image "FortiManager"   "$FORTINET_DIR/FortiManager"   "fortimanager.qcow2"

    [[ ! -f "$IMG_DIR/fgt-log.qcow2" ]] && run_silent "create FortiGate log disk ($FGT_LOG_SIZE)" sudo qemu-img create -f qcow2 "$IMG_DIR/fgt-log.qcow2" "$FGT_LOG_SIZE"
    [[ ! -f "$IMG_DIR/faz-data.qcow2" ]] && run_silent "create FAZ data disk ($FAZ_DATA_SIZE)" sudo qemu-img create -f qcow2 "$IMG_DIR/faz-data.qcow2" "$FAZ_DATA_SIZE"
    [[ ! -f "$IMG_DIR/fmg-data.qcow2" ]] && run_silent "create FMG data disk ($FMG_DATA_SIZE)" sudo qemu-img create -f qcow2 "$IMG_DIR/fmg-data.qcow2" "$FMG_DATA_SIZE"

    fix_permissions

    # Verify what we have
    echo ""
    info "Image check:"
    for img in fortigate.qcow2 fgt-log.qcow2 fortianalyzer.qcow2 faz-data.qcow2 fortimanager.qcow2 fmg-data.qcow2; do
        if [[ -f "$IMG_DIR/$img" ]]; then
            local sz; sz=$(sudo ls -lh "$IMG_DIR/$img" 2>/dev/null | awk '{print $5}')
            echo -e "    ${G}✔${RST} $img ${D}($sz)${RST}"
        else
            echo -e "    ${R}✖${RST} $img ${R}MISSING${RST}"
        fi
    done

    mark_step_done 5; log "Fortinet images extracted"
}

step6_deploy_vms() {
    step_header 6 "Deploy Fortinet VMs"
    fix_permissions

    deploy_vm() {
        local name="$1" ram="$2" cpu="$3"; shift 3
        local disk_args=() first_disk="$1"
        for d in "$@"; do disk_args+=(--disk "path=$d,format=qcow2,bus=virtio"); done
        if sudo virsh dominfo "$name" &>/dev/null; then echo -e "  ${D}⊘${RST} $name exists — skipping"; return; fi
        [[ ! -f "$first_disk" ]] && { err "$(basename "$first_disk") not found — cannot create $name"; return; }
        countdown "Deploying $name"
        try_fix "create $name" \
            "sudo virt-install --name $name --ram $ram --vcpus $cpu --cpu host-model --os-variant generic --import ${disk_args[*]} --network network=$NETWORK,model=virtio --graphics none --noautoconsole" \
            "sudo virsh destroy $name 2>/dev/null; sudo virsh undefine $name 2>/dev/null" "true"
    }

    deploy_vm "FortiGate"     $FGT_RAM $FGT_CPU "$IMG_DIR/fortigate.qcow2" "$IMG_DIR/fgt-log.qcow2"
    deploy_vm "FortiAnalyzer"  $FAZ_RAM $FAZ_CPU "$IMG_DIR/fortianalyzer.qcow2" "$IMG_DIR/faz-data.qcow2"
    deploy_vm "FortiManager"   $FMG_RAM $FMG_CPU "$IMG_DIR/fortimanager.qcow2"  "$IMG_DIR/fmg-data.qcow2"

    mark_step_done 6; log "Fortinet VMs deployed"
}

step7_init_disks() {
    step_header 7 "Initialize VM Disks (LVM Format)"
    command -v expect &>/dev/null || { warn "Installing expect..."; sudo apt install -y expect >>"$LOG_FILE" 2>&1; }

    init_fortinet_lvm() {
        local vm_name="$1" wait_time="${2:-90}"
        sudo virsh dominfo "$vm_name" &>/dev/null || { warn "$vm_name does not exist — skipping"; return; }
        local state; state=$(sudo virsh domstate "$vm_name" 2>/dev/null | tr -d '[:space:]')
        [[ "$state" != "running" ]] && { info "Starting $vm_name..."; sudo virsh start "$vm_name" 2>/dev/null || true; }
        info "Waiting ${wait_time}s for $vm_name to boot..."
        local elapsed=0
        while (( elapsed < wait_time )); do
            printf "\r  ${C}⏳${RST} ${D}$vm_name booting... %d/%ds${RST}  " "$elapsed" "$wait_time"
            sleep 5; ((elapsed+=5))
        done; printf "\r\033[K"

        info "Sending LVM commands to $vm_name..."
        sudo expect <<EXPECT_EOF >>"$LOG_FILE" 2>&1
set timeout 30
spawn virsh console $vm_name
expect {
    "login:" { send "admin\r"; expect { "Password:" { send "\r" } "#" {} "$ " {} } }
    "#" {} "$ " {}
    timeout { send "\r"; expect { "login:" { send "admin\r"; expect { "Password:" { send "\r" } "#" {} } } "#" {} "$ " {} } }
}
sleep 2; send "\r"; expect -re {[#$] }
send "execute lvm start\r"; expect -re {[#$] }; sleep 3
send "execute lvm extend\r"
expect { "Do you want to continue" { send "y\r"; expect -re {[#$] } } -re {[#$] } {} timeout {} }
sleep 2; send "\x1d"; sleep 1
EXPECT_EOF
        local rc=$?
        (( rc == 0 )) && echo -e "  ${G}✔${RST} $vm_name LVM initialized" || {
            warn "$vm_name LVM may need manual init"
            info "  sudo virsh console $vm_name → admin/(no pw) → execute lvm start → execute lvm extend"
        }
    }

    echo ""; info "Booting VMs and formatting data/log disks via FortiOS CLI..."; echo ""
    init_fortinet_lvm "FortiGate" 60
    init_fortinet_lvm "FortiAnalyzer" 90
    init_fortinet_lvm "FortiManager" 90
    echo ""
    info "If auto-init failed, run manually:"
    echo -e "    ${D}sudo virsh console <VM> → admin/(no pw) → execute lvm start → execute lvm extend${RST}"

    mark_step_done 7; log "VM disk init attempted"
}

step8_grub() {
    step_header 8 "GRUB — Windows Default + 10s Timeout"
    local grub_file="/etc/default/grub"
    [[ ! -f "$grub_file" ]] && { err "GRUB config not found"; mark_step_done 8; return; }

    # ── Fix os-prober (sed replace, not append) ──
    if grep -q "^GRUB_DISABLE_OS_PROBER" "$grub_file"; then
        sudo sed -i 's/^GRUB_DISABLE_OS_PROBER=.*/GRUB_DISABLE_OS_PROBER=false/' "$grub_file"
    elif grep -q "^#.*GRUB_DISABLE_OS_PROBER" "$grub_file"; then
        sudo sed -i 's/^#.*GRUB_DISABLE_OS_PROBER=.*/GRUB_DISABLE_OS_PROBER=false/' "$grub_file"
    else
        echo 'GRUB_DISABLE_OS_PROBER=false' | sudo tee -a "$grub_file" > /dev/null
    fi
    log "GRUB_DISABLE_OS_PROBER=false"

    # ── Timeout 5s ──
    grep -q "^GRUB_TIMEOUT=" "$grub_file" && sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=10/' "$grub_file" || echo 'GRUB_TIMEOUT=10' | sudo tee -a "$grub_file" > /dev/null
    log "GRUB_TIMEOUT=10"

    # ── Show menu (not hidden) ──
    sudo sed -i 's/^GRUB_TIMEOUT_STYLE=hidden/GRUB_TIMEOUT_STYLE=menu/' "$grub_file" 2>/dev/null
    grep -q "^GRUB_TIMEOUT_STYLE" "$grub_file" || echo 'GRUB_TIMEOUT_STYLE=menu' | sudo tee -a "$grub_file" > /dev/null

    # ── Try to mount Windows EFI if not already visible ──
    if ! sudo os-prober 2>/dev/null | grep -qi windows; then
        info "Windows not detected — attempting to find and mount EFI partition..."
        local efi_part
        efi_part=$(sudo fdisk -l 2>/dev/null | grep -i "EFI System" | awk '{print $1}' | head -1)
        if [[ -n "$efi_part" ]]; then
            info "Found EFI partition: $efi_part"
            sudo mkdir -p /boot/efi 2>/dev/null
            if ! mountpoint -q /boot/efi; then
                sudo mount "$efi_part" /boot/efi 2>>"$LOG_FILE" && log "Mounted $efi_part → /boot/efi" || warn "Failed to mount $efi_part"
            fi
            # Also add to fstab if missing
            if ! grep -q "$efi_part" /etc/fstab 2>/dev/null; then
                local efi_uuid; efi_uuid=$(sudo blkid -s UUID -o value "$efi_part" 2>/dev/null)
                if [[ -n "$efi_uuid" ]]; then
                    echo "UUID=$efi_uuid /boot/efi vfat defaults 0 1" | sudo tee -a /etc/fstab > /dev/null
                    log "Added EFI to fstab: UUID=$efi_uuid"
                fi
            fi
        else
            warn "No EFI partition found on disk"
        fi
    fi

    # ── Run os-prober + update-grub ──
    try_fix "os-prober" "sudo os-prober" "" "true"
    try_fix "update-grub" "sudo update-grub" "" "true"

    # ── Set Windows as default ──
    echo ""; info "Detecting Windows in GRUB..."
    local win_entry=""

    # Search grub.cfg for Windows entry string
    win_entry=$(sudo grep -oP "menuentry '\K[^']*[Ww]indows[^']*" /boot/grub/grub.cfg 2>/dev/null | head -1)

    if [[ -n "$win_entry" ]]; then
        # Set GRUB_DEFAULT to the Windows entry name
        if grep -q "^GRUB_DEFAULT=" "$grub_file"; then
            sudo sed -i "s/^GRUB_DEFAULT=.*/GRUB_DEFAULT=\"$win_entry\"/" "$grub_file"
        else
            echo "GRUB_DEFAULT=\"$win_entry\"" | sudo tee -a "$grub_file" > /dev/null
        fi
        log "Windows set as default: $win_entry"
        try_fix "update-grub (final)" "sudo update-grub" "" "true"
    else
        # Try numeric: look in os-prober output
        local os_prober_out
        os_prober_out=$(sudo os-prober 2>/dev/null)
        if echo "$os_prober_out" | grep -qi windows; then
            warn "os-prober sees Windows but GRUB didn't add it. Check /boot/efi mount."
        else
            warn "Windows not found — cannot set as default"
        fi
        info "After fixing, run: sudo grub-set-default 'Windows Boot Manager (on /dev/nvmeXnXpX)'"
    fi

    # ── Show entries ──
    echo ""; info "GRUB entries:"
    local idx=0
    while IFS= read -r entry; do
        echo -e "    ${B}[$idx]${RST} $entry"; ((idx++))
    done < <(sudo grep -oP "menuentry '\K[^']+" /boot/grub/grub.cfg 2>/dev/null | head -15)

    echo ""
    local final_default; final_default=$(grep "^GRUB_DEFAULT=" "$grub_file" 2>/dev/null)
    local final_timeout; final_timeout=$(grep "^GRUB_TIMEOUT=" "$grub_file" 2>/dev/null)
    info "Config: $final_default | $final_timeout"

    mark_step_done 8; log "GRUB updated"
}

step9_verify() {
    step_header 9 "Verify & Summary"
    echo ""

    start_spinner "Gathering info..."
    local vm_list dhcp_list grub_default grub_timeout
    vm_list=$(sudo virsh list --all 2>/dev/null)
    dhcp_list=$(sudo virsh net-dhcp-leases default 2>/dev/null)
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
    for img in fortigate.qcow2 fgt-log.qcow2 fortianalyzer.qcow2 faz-data.qcow2 fortimanager.qcow2 fmg-data.qcow2; do
        if [[ -f "$IMG_DIR/$img" ]]; then
            local sz; sz=$(sudo ls -lh "$IMG_DIR/$img" 2>/dev/null | awk '{print $5}')
            printf "  │ ${G}✔${RST} %-30s %s\n" "$img" "$sz"
        else
            printf "  │ ${R}✖${RST} %-30s %s\n" "$img" "MISSING"
        fi
    done
    echo -e "${W}  └──────────────────────────────────────────────────────────┘${RST}"
    echo ""
    echo -e "${W}  ┌─ GRUB Config ───────────────────────────────────────────┐${RST}"
    echo -e "  │ $grub_default"
    echo -e "  │ $grub_timeout"
    while IFS= read -r e; do echo -e "  │ ▸ $e"; done < <(sudo grep -oP "menuentry '\K[^']+" /boot/grub/grub.cfg 2>/dev/null | head -10)
    echo -e "${W}  └──────────────────────────────────────────────────────────┘${RST}"
    echo ""
    echo -e "  ${D}Fortinet path: $FORTINET_DIR${RST}"

    mark_step_done 9; log "Setup fully verified"
    echo ""
    echo -e "${G}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RST}"
    echo -ne "  ${G}"; typewrite "            ALL DONE — crafted by wolf" 0.04; echo -ne "${RST}"
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
    done; err "Unknown step: $num"; return 1
}

parse_steps() {
    local input="$1" result=()
    IFS=',' read -ra parts <<< "$input"
    for part in "${parts[@]}"; do
        part=$(echo "$part" | tr -d ' ')
        if [[ "$part" =~ ^([0-9]+)-([0-9]+)$ ]]; then
            for (( i=BASH_REMATCH[1]; i<=BASH_REMATCH[2]; i++ )); do (( i>=1 && i<=TOTAL_STEPS )) && result+=("$i"); done
        elif [[ "$part" =~ ^[0-9]+$ ]]; then (( part>=1 && part<=TOTAL_STEPS )) && result+=("$part"); fi
    done; printf '%s\n' "${result[@]}" | sort -n -u
}

# ── Menu ─────────────────────────────────────────────────────────────────────
show_steps_list() {
    echo ""
    for s in "${STEPS[@]}"; do
        IFS='|' read -r snum sname sfunc <<< "$s"
        if is_step_done "$snum"; then
            echo -e "    ${D}[$snum] $sname  ✔${RST}"
        else
            echo -e "    ${C}[$snum]${RST} $sname"
        fi
    done; echo ""
}

show_menu() {
    local next; next=$(get_next_undone)
    local done_count; done_count=$(get_done_count)
    echo -e "${W}  Select Mode:${RST}\n"
    if [[ "$next" == "done" ]]; then
        echo -e "    ${C}[1]${RST}  Auto-run all ${D}(all steps complete)${RST}"
    else
        echo -e "    ${C}[1]${RST}  Auto-run all (next: step $next)"
    fi
    echo -e "    ${C}[2]${RST}  Manual — pick steps  ${D}(e.g. 1-3  5,7-9  4)${RST}"
    echo -e "    ${C}[3]${RST}  Reset state & start fresh"
    echo -e "    ${C}[4]${RST}  Show progress"
    echo -e "    ${C}[5]${RST}  Change Fortinet path  ${D}(current: $FORTINET_DIR)${RST}"
    echo -e "    ${C}[0]${RST}  Quit\n"
    echo -ne "${Y}  ▸ Choice: ${RST}"
}

# ── Main ─────────────────────────────────────────────────────────────────────
main() {
    trap 'stop_spinner 2>/dev/null' EXIT INT TERM
    banner

    [[ $EUID -ne 0 ]] && ! sudo -n true 2>/dev/null && warn "This script needs sudo. You may be prompted for your password."

    [[ -f "$HOME/.wolf_fortinet_path" ]] && load_fortinet_path || select_fortinet_path

    start_spinner "Running default permission fixes..."
    fix_permissions >>"$LOG_FILE" 2>&1; stop_spinner
    echo -e "  ${G}✔${RST} Permissions checked\n"

    local done_count; done_count=$(get_done_count)
    local next; next=$(get_next_undone)
    if (( done_count > 0 )) && [[ "$next" != "done" ]]; then
        info "Resuming — completed $done_count/$TOTAL_STEPS steps"
        progress_bar "$done_count" "$TOTAL_STEPS"
    elif [[ "$next" == "done" ]]; then
        log "All steps completed! Use [3] to reset or [2] to re-run steps."
    fi

    while true; do
        show_menu; read -r choice
        case "$choice" in
            1)  local next; next=$(get_next_undone)
                [[ "$next" == "done" ]] && { warn "All steps done. Use [3] to reset."; continue; }
                for (( i=next; i<=TOTAL_STEPS; i++ )); do is_step_done "$i" || run_step "$i"; done; break ;;
            2)  while true; do
                    show_steps_list
                    echo -e "    ${D}Examples: 3  |  1-4  |  3-5,8  |  1,3,7-9${RST}\n"
                    echo -ne "${Y}  ▸ Enter steps (or 0 to go back): ${RST}"; read -r input
                    [[ "$input" == "0" ]] && break
                    local run_list; run_list=$(parse_steps "$input")
                    [[ -z "$run_list" ]] && { err "No valid steps"; continue; }
                    echo -e "\n${W}  Will run steps:${RST} $(echo $run_list | tr '\n' ' ')"
                    echo -ne "${Y}  ▸ Confirm? [Y/n]: ${RST}"; read -r confirm
                    [[ "${confirm,,}" == "n" ]] && continue
                    for s in $run_list; do run_step "$s"; done
                done ;;
            3)  reset_state; log "State reset"; banner; select_fortinet_path ;;
            4)  show_steps_list; progress_bar "$(get_done_count)" "$TOTAL_STEPS" ;;
            5)  select_fortinet_path ;;
            0)  echo ""; echo -ne "${D}  "; typewrite "crafted by wolf — see you next boot." 0.03; echo -e "${RST}"; exit 0 ;;
            *)  err "Invalid choice" ;;
        esac
    done
}

main "$@"
