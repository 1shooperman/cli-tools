convert_vid() {
    local silent=0
    local input=""

    for arg in "$@"; do
        if [[ "$arg" == "--silent" ]]; then
            silent=1
        else
            input="$arg"
            break
        fi
    done

    if ! command -v ffmpeg &>/dev/null; then
        echo "convert_vid: ffmpeg is not installed. Please install ffmpeg to use this function." >&2
        return 1
    fi

    if [[ -z "$input" ]]; then
        echo "convert_vid: usage: convert_vid [--silent] <input-file>" >&2
        return 1
    fi

    if [[ ! -f "$input" ]]; then
        echo "convert_vid: input file not found: $input" >&2
        return 1
    fi

    local output="${input%.*}.mp4"

    if [[ $silent -eq 1 ]]; then
        ffmpeg -i "$input" -vcodec libx264 -crf 23 -preset medium -acodec aac -b:a 128k "$output" &>/dev/null
    else
        ffmpeg -i "$input" -vcodec libx264 -crf 23 -preset medium -acodec aac -b:a 128k "$output"
    fi
}
