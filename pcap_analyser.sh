#!/bin/bash

LOG_FILE="pcap_analyser.log"
CURRENT_DIR=$(pwd)

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
    echo "File name:\"$entry\" is done!!!"
    echo "$entry" >> pcaplist
}

if [[ $# -ne 1 ]]; then
    log_error "Please provide the pcap directory as a command line argument."
    exit 1
fi

PCAP_PATH="$1"
cd "$PCAP_PATH" 
if [[ ! -d "$PCAP_PATH" ]]; then
    log_error "The provided path is not a valid directory: $PCAP_PATH"
    exit 1
fi

log_info "Following ip address has packet conversation with victim machine:" > result.txt
log_info "Analyzing pcap files in directory: $PCAP_PATH"

start_time=$(date +%Y-%m-%d\ %H:%M:%S)
log_info "Scan started at: $start_time"

echo "" > pcaplist
echo "" > result.txt
echo "" > conversation_list.txt

python3 "$CURRENT_DIR/black_list_parser.py" "$CURRENT_DIR" >> "$LOG_FILE" 2>&1

while IFS= read -r -d '' entry; do
    analyse
done < <(find "$PCAP_PATH" -type f -name "*.pcap" -print0)

end_time=$(date +%Y-%m-%d\ %H:%M:%S)
log_info "Scan completed at: $end_time"
scanned_files=$(sed -i '1d' pcaplist  && cat pcaplist | wc -l)
log_info "Number of files scanned: $scanned_files"

python3 "$CURRENT_DIR/conversation_parser.py" >> "$LOG_FILE" 2>&1
unique_ips=$(sed -i '1d' conversation_list.txt && cat conversation_list.txt | wc -l)
log_info "Number of unique IPs found: $unique_ips"

malicious_ips=$(grep -oP '^\s+\K\S+' result.txt | sort | wc -l)
if [[ $malicious_ips -gt 0 ]]; then
    log_info "Number of malicious IPs found: $malicious_ips"
    log_info "Malicious IPs found:"
    sed '1d' "$PCAP_PATH/result.txt" | cat
    sed '1d' "$PCAP_PATH/result.txt" | cat >> "$LOG_FILE" 2>&1

else
    log_info "No malicious IP addresses found"
fi

log_info "Pcap analysis completed!"
log_info "Pcap analysis log have been saved in $PCAP_PATH/pcap_analyser.log"
cd "$PCAP_PATH" && rm black_list.txt && rm ip_count.csv && rm pcaplist && rm result.txt
mkdir "$PCAP_PATH/AnalyzingResult" && mv "$PCAP_PATH/conversation_list.txt" "$PCAP_PATH/AnalyzingResult" && mv "$PCAP_PATH/pcap_analyser.log" "$PCAP_PATH/AnalyzingResult"