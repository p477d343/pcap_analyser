import pandas as pd
import logging
import sys
import os

LOG_FILE = "pcap_analyser.log"

# 設置日誌的配置
logging.basicConfig(filename=LOG_FILE, level=logging.INFO, format='%(asctime)s %(levelname)s: %(message)s')

def log_info(message):
    logging.info(message)

def log_error(message):
    logging.error(message)

if len(sys.argv) != 2:
    log_error("Please provide the current directory as a command line argument.")
    sys.exit(1)

current_dir = sys.argv[1]
blacklist_file = os.path.join(current_dir, "blacklist.xlsx")

df = pd.read_excel(blacklist_file)

blacklist = []
for i in range(len(df.values)):
    blacklist.append(str(df.values[i]).replace("'", "").replace("[", "").replace("]", ""))

black_list = list(set(blacklist))

with open("black_list.txt", "w+") as file:
    content = "\n".join(black_list) + '\n'
    file.write(content)

log_info("Blacklist IPs have been saved in black_list.txt")