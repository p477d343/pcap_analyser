#!/bin/bash

LOG_FILE="pcap_analyser.log"

function log_info() {
    echo "[INFO] $1"
    echo "[INFO] $1" >> "$LOG_FILE"
}

function log_error() {
    echo "[ERROR] $1"
    echo "[ERROR] $1" >> "$LOG_FILE"
}

function startfunc() {
	read -p "Please enter your pcap path:" PCAP_PATH
	log_info "Your pcap path is $PCAP_PATH"
	read -p "Is this path correct?[y/n]:" yesorno
	if [[ $yesorno = "y" ]]; then
		cd "$PCAP_PATH" || { log_error "Unable to change directory to $PCAP_PATH"; exit 1; }
		confirm=true
	else
		confirm=false
	fi
}

function analyse() {
	tshark -r "$entry" -qz conv,ip > pcap.txt
	log_info "Analyzing file: $entry"
	echo "File name:\"$entry\" contain following malicious ip address:" >> result.txt
	python3 /home/kali/pcap_analyser/pcap_analyser.py >> "$LOG_FILE" 2>&1
	rm pcap.txt
	echo $"File name:\"$entry\" is done!!!"
	echo "$entry" >> pcaplist
}

log_info "Following ip address has packet conversation with victim machine:" > result.txt
confirmval=true

while [[ "$confirmval" != false ]]; do
	confirm=true
	startfunc
	echo "" > pcaplist
	echo "" > result.txt
	echo "" > conversation_list.txt
	if [[ $confirm != false ]]; then
		log_info "Analyzing pcap files in directory: $PCAP_PATH"
		python3 /home/kali/pcap_analyser/black_list_parser.py >> "$LOG_FILE" 2>&1
		while IFS= read -r -d '' entry; do
			analyse
		done < <(find "$PCAP_PATH" -type f -name "*.pcap" -print0)
		confirmval=false
	else
		log_info "Retype your pcap path"
		break
	fi
done

python3 /home/kali/pcap_analyser/conversation_parser.py >> "$LOG_FILE" 2>&1
wc -l conversation_list.txt
cat result.txt

log_info "Pcap analysis completed!"
