#!/usr/bin/env python
# coding: utf-8
import logging
import pandas as pd
import sys

LOG_FILE = "pcap_analyser.log"

logging.basicConfig(filename=LOG_FILE, level=logging.INFO, format='%(asctime)s %(levelname)s: %(message)s')

def log_info(message):
    logging.info(message)

def log_error(message):
    logging.error(message)

with open("pcap.txt", "r", encoding="utf-8") as f:
    pcap = f.read().split('\n')

def not_empty(s):
    return s and s.strip()

ip_list = []
for i in range(5, len(pcap)-2):
    pcap[i] = list(filter(not_empty, pcap[i].replace("<->", "").split(" ")))
    ip_list.extend(pcap[i][:2])

final_list = list(set(ip_list))

with open("black_list.txt", "r", encoding="utf-8") as bl:
    black_list = bl.read().split('\n')

result = list(set(final_list) & set(black_list))
if len(result) != 0:
    with open("result.txt", "a+") as result_file:
        result_content = ""
        for i in range(len(result)):
            result_content += "\t" + result[i] + '\n'
        result_file.write(result_content)
    log_info("Malicious IP addresses found and saved in result.txt")
else:
    log_info("No malicious IP addresses found")

with open("conversation_list.txt", "a+") as final_file:
    final_content = "\n".join(final_list) + '\n'
    final_file.write(final_content)

log_info("IP addresses have been saved in conversation_list.txt")

df = pd.DataFrame(ip_list, columns=['IP Address'])
ip_count = df['IP Address'].value_counts()
ip_count.to_csv("ip_count.csv")
log_info("IP address count has been saved in ip_count.csv")
