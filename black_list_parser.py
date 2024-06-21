import pandas as pd
import logging

LOG_FILE = "pcap_analyser.log"

# 設置日誌的配置
logging.basicConfig(filename=LOG_FILE, level=logging.INFO, format='%(asctime)s %(levelname)s: %(message)s')

def log_info(message):
    logging.info(message)

def log_error(message):
    logging.error(message)
    
df = pd.read_excel(r'/home/kali/pcap_analyser/blacklist.xlsx')

blacklist = []
for i in range(len(df.values) - 1):
    blacklist.append(str(df.values[i]).replace("'", "").replace("[", "").replace("]", ""))

black_list = list(set(blacklist))

with open("black_list.txt", "w+") as file:
    content = "\n".join(black_list) + '\n'
    file.write(content)

log_info("Blacklist IPs have been saved in black_list.txt")
