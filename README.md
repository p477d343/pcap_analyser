# PCAP Analyzer

The PCAP Analyzer is a tool for analyzing PCAP (packet capture) files to identify malicious IP addresses and generate various reports.

## Prerequisites

- Python 3.x
- pandas library (`pip install pandas`)
- tshark (part of the Wireshark package)

## Usage

1. Clone the repository:

   ```
   git clone https://github.com/your-username/pcap-analyzer.git
   cd pcap-analyzer
   ```

2. Prepare a blacklist file named `blacklist.xlsx` in the project directory. The file should contain a list of known malicious IP addresses.

3. Run the PCAP analyzer script:

   ```
   ./pcap_analyser.sh /path/to/pcap/directory
   ```

   Replace `/path/to/pcap/directory` with the actual path to the directory containing the PCAP files you want to analyze.

4. The script will analyze each PCAP file in the specified directory and generate the following files:

   - `conversation_list.txt`: A list of unique IP addresses found in the PCAP files.
   - `ip_count.csv`: A CSV file containing the count of each IP address.
   - `result.txt`: A file containing the malicious IP addresses found in the PCAP files.
   - `pcap_analyser.log`: A log file containing detailed information about the analysis process.

5. After the analysis is complete, the script will move the `conversation_list.txt` and `pcap_analyser.log` files to a new directory named `AnalyzingResult` within the PCAP directory.

## Scripts

- `pcap_analyser.sh`: The main script that orchestrates the PCAP analysis process.
- `pcap_analyser.py`: Python script that analyzes individual PCAP files and identifies malicious IP addresses.
- `black_list_parser.py`: Python script that parses the `blacklist.xlsx` file and generates a `black_list.txt` file containing the malicious IP addresses.
- `conversation_parser.py`: Python script that removes duplicate IP addresses from the `conversation_list.txt` file.

## Logging

The PCAP Analyzer uses the Python logging module to log information and errors during the analysis process. The log messages are written to the `pcap_analyser.log` file.

## Dependencies

The PCAP Analyzer relies on the following dependencies:

- pandas: A Python library for data manipulation and analysis.
- tshark: A command-line network protocol analyzer, which is part of the Wireshark package.

Make sure you have these dependencies installed before running the PCAP Analyzer.

## Contributing

Contributions to the PCAP Analyzer project are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request on the GitHub repository.

## License

This project is licensed under the [MIT License](LICENSE).

