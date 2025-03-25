import os
import shutil

def create_year_folders_and_sort_files(base_dir):
    """
    Create year folders from 1988 to 2018 and organize files into these folders
    based on the year in their filename.
    
    :param base_dir: Path to the directory containing the files to organize.
    """
    # Create folders for each year from 1988 to 2018
    years = range(1988, 2019)
    for year in years:
        year_folder = os.path.join(base_dir, str(year))
        os.makedirs(year_folder, exist_ok=True)
    
    # List all files in the base directory
    for file_name in os.listdir(base_dir):
        file_path = os.path.join(base_dir, file_name)
        
        # Skip directories
        if not os.path.isfile(file_path):
            continue
        
        # Match the file name pattern and extract the year
        if file_name.startswith("CHELSA_tas_") and "_V.2.1" in file_name:
            try:
                year = file_name.split("_")[3]  # Extract year from filename
                if year.isdigit() and int(year) in years:
                    # Move the file to the corresponding year folder
                    destination = os.path.join(base_dir, year, file_name)
                    shutil.move(file_path, destination)
                    print(f"Moved {file_name} to folder {year}")
            except IndexError:
                print(f"Filename {file_name} doesn't match the expected format.")
        else:
            print(f"Skipped {file_name}, doesn't match the pattern.")

# Example usage
base_directory = "E:\RAW DATA"  # Replace with your directory path
create_year_folders_and_sort_files(base_directory)