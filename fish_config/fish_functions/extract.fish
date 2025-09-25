function extract --description "Extract various archive formats"
    if test -z "$argv[1]"
        echo "Usage: extract <archive_file>"
        return 1
    end
    
    if not test -f "$argv[1]"
        echo "Error: '$argv[1]' is not a valid file"
        return 1
    end
    
    switch "$argv[1]"
        case "*.tar.bz2"
            tar xjf "$argv[1]"
        case "*.tar.gz"
            tar xzf "$argv[1]"
        case "*.bz2"
            bunzip2 "$argv[1]"
        case "*.rar"
            unrar x "$argv[1]"
        case "*.gz"
            gunzip "$argv[1]"
        case "*.tar"
            tar xf "$argv[1]"
        case "*.tbz2"
            tar xjf "$argv[1]"
        case "*.tgz"
            tar xzf "$argv[1]"
        case "*.zip"
            unzip "$argv[1]"
        case "*.Z"
            uncompress "$argv[1]"
        case "*.7z"
            7z x "$argv[1]"
        case "*"
            echo "Error: '$argv[1]' cannot be extracted via extract()"
            return 1
    end
    
    echo "Successfully extracted: $argv[1]"
end
