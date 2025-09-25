function weather --description "Get weather information for a location"
    if test (count $argv) -eq 0
        # Default to current location
        curl -s "wttr.in/?format=3"
    else
        # Get weather for specified location
        curl -s "wttr.in/$argv[1]?format=3"
    end
end
