#!/bin/bash

readonly LOG_FILE="pcap_analyser.log"
readonly CURRENT_DIR=$(pwd)
readonly PCAP_PATH="$1"
readonly ANALYZING_RESULT_DIR="$PCAP_PATH/AnalyzingResult"
readonly PORT=8787

function log_info() {
    echo "[INFO] $1"
    echo "[INFO] $1" >> "$LOG_FILE"
}

function log_error() {
    echo "[ERROR] $1"
    echo "[ERROR] $1" >> "$LOG_FILE"
}

function analyse() {
    tshark -r "$entry" -qz conv,ip > pcap.txt
    log_info "Analyzing file: $entry"
    python3 "$CURRENT_DIR/pcap_analyser.py" "$entry">> "$LOG_FILE" 2>&1
    rm pcap.txt
    echo "$entry" >> pcaplist
}

if [[ $# -ne 1 ]]; then
    log_error "Please provide the pcap directory as a command line argument."
    exit 1
fi

cd "$PCAP_PATH" 
if [[ ! -d "$PCAP_PATH" ]]; then
    log_error "The provided path is not a valid directory: $PCAP_PATH"
    exit 1
fi

log_info "Analyzing pcap files in directory: $PCAP_PATH"

start_time=$(date +%Y-%m-%d\ %H:%M:%S)
log_info "Scan started at: $start_time"

echo "" > pcaplist
echo "" > result.txt
echo "" > conversation_list.txt

python3 "$CURRENT_DIR/black_list_parser.py" "$CURRENT_DIR" >> "$LOG_FILE" 2>&1
curl --compressed https://raw.githubusercontent.com/stamparm/ipsum/master/ipsum.txt 2>/dev/null | grep -v "#" | grep -v -E "\s[0]$" | cut -f 1 >> "$PCAP_PATH/black_list.txt" 

total_size=0
while IFS= read -r -d '' entry; do
    analyse
    file_size=$(stat -c%s "$entry")
    total_size=$((total_size + file_size))
done < <(find "$PCAP_PATH" -type f -name "*.pcap" -print0)

end_time=$(date +%Y-%m-%d\ %H:%M:%S)
scanned_files=$(sed -i '1d' pcaplist  && cat pcaplist | wc -l)
data_scanned=$((total_size / 1024 / 1024))
elapsed_time=$(($(date -d "$end_time" +%s) - $(date -d "$start_time" +%s)))
minutes=$((elapsed_time / 60))
seconds=$((elapsed_time % 60))

python3 "$CURRENT_DIR/conversation_parser.py" >> "$LOG_FILE" 2>&1
unique_ips=$(sed -i '1d' conversation_list.txt && cat conversation_list.txt | wc -l)

malicious_ips=$(grep -oP '^\s+\K\S+' result.txt | sort | wc -l)
blacklist_ips=$(wc -l < "$PCAP_PATH/black_list.txt")

if [[ $malicious_ips -gt 0 ]]; then
    log_info "Number of malicious IPs found: $malicious_ips"
    log_info "Malicious IPs found:"
    sed '1d' "$PCAP_PATH/result.txt" | cat
    sed '1d' "$PCAP_PATH/result.txt" | cat >> "$LOG_FILE" 2>&1

else
    log_info "No malicious IP addresses found"
fi

log_info "----------- SCAN SUMMARY -----------"
log_info "Known blacklisted IPs: $blacklist_ips"
log_info "Scanned files: $scanned_files"
log_info "Malicious IPs found: $malicious_ips"
log_info "Unique IPs found: $unique_ips"
log_info "Pcap scanned size: $data_scanned MB"
log_info "Time: $elapsed_time sec ($minutes m $seconds s)"
log_info "Start Date: $start_time"
log_info "End Date:   $end_time"


log_info "Pcap analysis completed!"
log_info "Pcap analysis log have been saved in $PCAP_PATH/pcap_analyser.log"
cd "$PCAP_PATH" && rm black_list.txt pcaplist result.txt
if [ ! -d "$PCAP_PATH/AnalyzingResult" ]; then
  mkdir "$PCAP_PATH/AnalyzingResult"
fi

mkdir -p "$ANALYZING_RESULT_DIR"
mv conversation_list.txt pcap_analyser.log "$ANALYZING_RESULT_DIR"

cd "$PCAP_PATH"
zip -r AnalyzingResult.zip AnalyzingResult