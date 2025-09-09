#!/bin/bash

# To use, run : 
#	chmod +x auto-nmap.sh
#	./auto-nmap.sh <target-ip>

# Declaration of Variables

TARGET=$1
OUTPUT_DIR="Auto-nmap-results"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S") #Format : Year/Month/Day/Hour/Minute/Second
OUTPUT_FILE="$OUTPUT_DIR/scan_${TARGET}_${TIMESTAMP}.txt"

mkdir -p $OUTPUT_DIR  #skip if alr exists

if [ -z "$TARGET" ]; then

	echo "Usage: $0 <target>"
	exit 1

fi

echo "[*] Running basic auto scan on $TARGET..."

#Fast Scan
echo "[*] Starting Fast Scan on 100 ports on $TARGET..."
nmap -T4 -F -sV -O --script=vuln $TARGET -oN ${OUTPUT_FILE}_fast.txt
echo "[*] Fast Scan complete. Results saved to $OUTPUT_FILE_fast.txt"

# Full TCP scan + service detection
echo -e "\n[+] Running service scan..."
nmap -T4 -sV -p- $TARGET -oN ${OUTPUT_FILE}_services.txt

# OS detection
echo -e "\n[+] Detecting OS..."
nmap -O $TARGET -oN ${OUTPUT_FILE}_os.txt

# Basic vulnerability Scan
echo -e "\n[+] Running vulnerability scan..."
nmap --script vuln $TARGET -oN ${OUTPUT_FILE}_vuln.txt

# Merging into one file
cat ${OUTPUT_FILE}_fast.txt \
    ${OUTPUT_FILE}_services.txt \
    ${OUTPUT_FILE}_os.txt \
    ${OUTPUT_FILE}_vuln.txt > $OUTPUT_FILE

echo -e "\n[*] Scan complete. Results saved to $OUTPUT_FILE"

