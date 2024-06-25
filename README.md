# PCAP Analyzer

The PCAP Analyzer is a tool for analyzing PCAP (packet capture) files to identify malicious IP addresses and generate various reports.

## Features

- Analyzes PCAP files in a specified directory
- Identifies malicious IP addresses based on a provided blacklist and the stamparm/ipsum threat intelligence feed
- Generates a list of unique IP addresses found in the PCAP files
- Provides a summary of the analysis results, including the number of scanned files, malicious IPs found, and unique IPs found
- Logs detailed information about the analysis process for better transparency and debugging

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

4. The script will analyze each PCAP file in the specified directory and generate the following files in the `AnalyzingResult` directory:

   - `conversation_list.txt`: A list of unique IP addresses found in the PCAP files.
   - `pcap_analyser.log`: A log file containing detailed information about the analysis process.

5. After the analysis is complete, the script will display a summary of the results, including:

   - Number of known blacklisted IPs
   - Number of scanned files
   - Number of malicious IPs found
   - Number of unique IPs found
   - Size of the analyzed PCAP files
   - Analysis duration

6. The script will also create a zip file named `AnalyzingResult.zip` in the PCAP directory, containing the `AnalyzingResult` directory for easy sharing and distribution of the analysis results.

## Integration with stamparm/ipsum

This project integrates the [stamparm/ipsum](https://github.com/stamparm/ipsum) threat intelligence feed to enhance the malicious IP detection capabilities. The ipsum repository provides a daily updated list of suspicious and malicious IP addresses sourced from over 30 different public blacklists.

During the analysis process, the script fetches the latest ipsum IP list and combines it with the provided `blacklist.xlsx` file. This significantly expands the coverage of potentially malicious IPs.

### Customization

By default, the script uses the ipsum.txt file, which includes all IPs from the ipsum feed. If you prefer to use a different level of IP list (e.g., only IPs found on 3 or more blacklists), you can modify the following line in the `pcap_analyser.sh` script:

```bash
curl --compressed https://raw.githubusercontent.com/stamparm/ipsum/master/ipsum.txt 2>/dev/null | grep -v "#" | grep -v -E "\s[0]$" | cut -f 1 >> "$PCAP_PATH/black_list.txt"
```

Replace `"\s[0]$`(using level 1 to 10,) with the desired level file (e.g., `"\s[1-2]$"`:using level 3 to 10).
Greater the number, lesser the chance of false positive detection and/or dropping in (inbound) monitored traffic

## Scripts

- `pcap_analyser.sh`: The main script that orchestrates the PCAP analysis process.
- `pcap_analyser.py`: Python script that analyzes individual PCAP files and identifies malicious IP addresses.
- `black_list_parser.py`: Python script that parses the `blacklist.xlsx` file and generates a `black_list.txt` file containing the malicious IP addresses.
- `conversation_parser.py`: Python script that removes duplicate IP addresses from the `conversation_list.txt` file.

## Logging

The PCAP Analyzer uses the Python logging module to log information and errors during the analysis process. The log messages are written to the `pcap_analyser.log` file, which can be found in the `AnalyzingResult` directory after the analysis is complete.

## Dependencies

The PCAP Analyzer relies on the following dependencies:

- pandas: A Python library for data manipulation and analysis.
- tshark: A command-line network protocol analyzer, which is part of the Wireshark package.

Make sure you have these dependencies installed before running the PCAP Analyzer.

## Contributing

Contributions to the PCAP Analyzer project are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request on the GitHub repository.

## License

This project is licensed under the [MIT License](LICENSE).