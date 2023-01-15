#!/bin/bash
Help()
{
   # Display Help
   echo "This script checks how full a directory is and deletes files if it goes over a threshold."
   echo
   echo "Syntax: checkservice [-m|-t|-d|-f|-h]"
   echo "options:"
   echo "-m    Directory to check."
   echo "-t    Size threshold."
   echo "-d    Sets limit on how old files must be to be deleted."
   echo "-f    The file type to be deleted. e.g .log, .txt... provide only one and with a period before the extension."
   echo "-h    Print help."
   echo
}

process_arguments() {
    if [[ -z "$1" ]];
    then
    Help
    exit 1
    fi

    while [ -n "$1" ]
    do
        case $1 in
            -h|--help) Help; exit 1;;
            -m) if [[ -d $2 ]]; then 
                    export directory=$2
                    shift
                    shift 
                else
                    echo "Directory not found, provide a correct directory. Exiting" 
                    exit 1
                fi
                ;;
            -t) if [[ $2 =~ ^[0-9]+$ ]]; then
                    export size=$2
                    shift
                    shift
                else
                    echo "Not a valid size, enter a valid integer"
                    exit 1
                fi
                ;;
            -d) if [[ $2 =~ ^[0-9]+$ ]]; then
                    export days=$2
                    shift
                    shift
                else
                    echo "Not a valid age, enter a valid integer"
                    exit 1
                fi
                ;;
            -f) if [[ $2 =~ ^\. ]]; then
                    export file_extension=$2
                    shift
                    shift
                else
                    echo "Please provide a file extension starting with ."
                    exit 1
                fi
                ;;
            *) Help; exit 1;;
        esac
    done
}

process_arguments "$@"

# Check if all values have been provided
if [[ -z $size || -z $days || -z $directory || -z $file_extension ]]; then
echo "Missing parameters, see help"
Help
exit 1
fi

# Check directory space left
dir_use_percent=$(findmnt -T "$directory" -o USE% | tail -1 | sed s/%//g)
if (( dir_use_percent > size )); then
    printf "%s%s%s%s%s\n" "Disk usage is at " "$dir_use_percent" "% deleting files with extension: " "$file_extension" "..."
    find "$directory" -type f \"$"file_extension"\" -mtime +"$days" -exec rm {} \;
fi