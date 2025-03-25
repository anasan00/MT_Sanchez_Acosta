import os
import requests

def download_files(file_path, output_dir):
    """
    Download files from URLs listed in a text file.
    
    :param file_path: Path to the text file containing the URLs.
    :param output_dir: Directory to save the downloaded files.
    """
    # Create the output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    with open(file_path, 'r') as file:
        urls = file.readlines()  # Read all lines from the file
    
    for index, url in enumerate(urls):
        url = url.strip()  # Remove any surrounding whitespace or newlines
        if not url:
            continue  # Skip empty lines
        
        try:
            print(f"Downloading file {index + 1} from {url}...")
            response = requests.get(url, stream=True)
            response.raise_for_status()  # Check for HTTP errors
            
            # Extract filename from the URL
            filename = os.path.basename(url.split('?')[0])  # Strip query parameters
            file_path = os.path.join(output_dir, filename)
            
            # Save the file
            with open(file_path, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)
            
            print(f"File saved to {file_path}")
        except requests.exceptions.RequestException as e:
            print(f"Failed to download {url}: {e}")

# Example usage
text_file = "paths_temp.txt"  # Replace with your text file's path
output_directory = "RAW DATA"  # Replace with your desired output directory
download_files(text_file, output_directory)