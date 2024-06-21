from collections import OrderedDict
import logging

LOG_FILE = "pcap_analyser.log"

# 設置日誌的配置
logging.basicConfig(filename=LOG_FILE, level=logging.INFO, format='%(asctime)s %(levelname)s: %(message)s')

def log_info(message):
    logging.info(message)

def log_error(message):
    logging.error(message)
    
with open("conversation_list.txt", "r+", encoding="utf-8") as file:
    content = file.read()

final_list = list(OrderedDict.fromkeys(content.split("\n")))

with open("conversation_list.txt", "w+", encoding="utf-8") as file:
    file.write("\n".join(final_list) + '\n')

log_info("Unique IP addresses have been saved in conversation_list.txt")
