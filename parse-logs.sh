# fork of https://www.abuseipdb.com/parse-logs.sh
# changes : 
#  - easier to put in cronjobs
#  - remove duplicates IPs
# You need to change lines 24 and 26, with you log path and apikey

#!/bin/sh

# By default, this is not a dry run.
dryRun=0

# Options, a while loop will allow us to add more options in the future.
while getopts "d" opt; do
	case $opt in
		d) echo "Performing dry run. Results will not submitted to AbuseIPDB"; dryRun=1 ;;
		\?) echo "Invalid option: -$OPTARG" >&2 ;;
	esac
done

# Skip over the processed options.
shift $((OPTIND-1))

# Operand: the file to parse.
secureLogFile=/var/log/auth.log
# Operand: the API key of the AbuseIPDB user.
key=

# Standard operand checking.
if [ -z $secureLogFile ]; then
	echo "Missing input file. Aborting." >&2
	exit 1;
elif [ ! -r $secureLogFile ]; then
	echo "File does not exist or is not readable. Aborting." >&2
	exit 1;
elif [ -z $key ] && [ $dryRun -eq 0 ]; then
	echo "Missing API Key" >&2
	exit 1;
fi


# pcregrep is not preinstalled on many linux distros.
# It's shipped in the "pcre-tools" package for RedHat/Fedora.
if [ ! -x "$(command -v pcregrep)" ]; then
	echo "Command 'pcregrep' required, but is not installed. Aborting." >&2
	exit 1;
fi

# Pick the Unit Separator (non-printing character) to delimit the fields.
unit_sep=$'\031'

# Find the pattern matches for an invalid user.
pcregrep -o1 -o2 -o3 --om-separator="$unit_sep" -e '([a-zA-Z]+ [0-9]+ [0-9]+:[0-9]+:[0-9]+) .* (Invalid user [a-zA-Z0-9]+ from (([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})) port [0-9]+)' $secureLogFile > matches.txt

# Create CSV headers.
echo "IP,Categories,ReportDate,Comment" > report.csv

# Rearrange the order of the fields for our bulk uploader.
# IP & ReportDate generally don't need to be enclosed, but we'll play it safe.
gawk -F "$unit_sep" 'BEGIN {OFS=","} {print "\""$3"\",\"18,22\",\""$1"\",\""$2"\""}' matches.txt >> report.csv

# Clean up. Comment out if you want to peruse the matches.
rm matches.txt

awk '!v[$1]++' report.csv > report_final.csv
# Remove duplicate IP from report.csv and put it in report_final.csv
# src: https://unix.stackexchange.com/a/346707

# Check dry run option.
if [ $dryRun -eq 0 ]; then
	# Report to AbuseIPDB.
	curl https://api.abuseipdb.com/api/v2/bulk-report \
        -F csv=@report_final.csv \
        -H "Key: $key" \
    	-H "Accept: application/json" \
    	> output.json
fi

exit 0;
