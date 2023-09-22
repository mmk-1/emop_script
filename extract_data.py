import sys
import re

# Read the project name from the command line
project = sys.argv[1]

# Define the file paths
file_paths = [f"results/{project}/{file}" for file in ["hrps.txt", "mrps.txt", "rps.txt"]]

# Define the patterns to match
info_pattern = "INFO: (.+: \d+)"
time_pattern = "\[INFO\] Total time: (\d+:\d+) min"

# Process each file
for file_path in file_paths:
    with open(file_path, 'r') as file:
        data = file.read().split("=====")
        for commit in data:
            # Search for INFO lines
            info_matches = re.findall(info_pattern, commit)
            for match in info_matches:
                print(f"{match}")

            # Search for TOTAL TIME line
            time_match = re.search(time_pattern, commit)
            if time_match:
                print(f"Total time: {time_match.group(1)}")
