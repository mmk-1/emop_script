import sys
import re

# Read the project name from the command line
project = sys.argv[1]

# Define the file paths
file_paths = [f"results/{project}/{file}" for file in ["hrps.txt", "mrps.txt", "rps.txt"]]

# Define the patterns to match
info_pattern = "INFO: (.+: \d+)"
time_pattern = "\[INFO\] Total time:(.*)"
results_str = ""

# Process each file
for file_path in file_paths:
    with open(file_path, 'r') as file:
        # The weird splitting below is to curate the relevant data that corresponds to one commit
        data = file.read().split("================================")
        data = "\n".join(data).strip()
        data = [item for item in data.split("=====") if item]
        i = 1 # Commit counter (placeholder for commit SHA)
        for commit in data:
            results_str = f"{project}:{i}:{file_path}: "
            i+=1
            # Search for INFO lines
            info_matches = re.findall(info_pattern, commit)
            for match in info_matches:
                results_str += ","+ match
                print(f"{match}")

            # Search for TOTAL TIME line
            time_match = re.search(time_pattern, commit)
            if time_match:
                results_str += "," + "Total time: " + time_match.group(1)
                print(f"Total time: {time_match.group(1)}")

            with open("result_table.csv", "a") as result_table:
                result_table.write(results_str+"\n") 
