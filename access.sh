CONFIG="config.txt"
IPADDRESS="ip.txt"
if [ ! -f "$CONFIG" ]; then
    echo "Environment definitions file not found: $CONFIG"
    exit 1
fi
while IFS=':' read -r key value; do
    if [ -n "$key" ] && [ -n "$value" ]; then
        # Replace ~ with $HOME for home directory expansion
        value="${value/#\~/$HOME}"
        export "$key=$value"
        echo "Exported $key=$value"
    fi
done < "$CONFIG"

 if [ ! -f "$IPADDRESS" ]; then
     echo "Environment definitions file not found: $IPADDRESS"
     exit 1
 fi
 while IFS=':' read -r key value; do
     if [ -n "$key" ] && [ -n "$value" ]; then
         # Replace ~ with $HOME for home directory expansion
         value="${value/#\~/$HOME}"
         export "$key=$value"
         echo "Exported $key=$value"
     fi
 done < "$IPADDRESS"
git pull
# ssh a2@34.118.33.165 /opt/conda/bin/python transcribe.py "https://youtu.be/q6L82zI1_D0?si=Ut-wtAZ9_7fAjzgQ" > darknet_diaries100.txt

# Function to ask for user confirmation
ask_confirmation() {
    while true; do
        read -p "File already exists. Do you want to proceed? (y/n) " yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
}

# Prompt the user for input
read -p "Enter the filename: " filename

# Ensure the filename ends with .txt
if [[ $filename != *.txt ]]; then
    filename="${filename}.txt"
fi

# Check if the file exists
if [ -f "$filename" ]; then
    echo "The file '$filename' already exists."
    ask_confirmation
else
    # Create the file if it doesn't exist
    touch "$filename"
    echo "The file '$filename' has been created."
fi


ssh $A@$IPADDRTS /opt/conda/bin/python transcribe.py "$1" > $filename
