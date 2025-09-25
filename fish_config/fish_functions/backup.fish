function backup --description "Create a backup copy of a file or directory"
    if test -z "$argv[1]"
        echo "Usage: backup <file_or_directory>"
        return 1
    end
    
    set -l target "$argv[1]"
    set -l backup_name "$target.backup.(date +%Y%m%d_%H%M%S)"
    
    if test -e "$target"
        cp -r "$target" "$backup_name"
        echo "Backup created: $backup_name"
    else
        echo "Error: '$target' does not exist"
        return 1
    end
end
