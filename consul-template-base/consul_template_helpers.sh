# These are used inside various .service files

wait_for_file() {
    while [ ! -f "$1" ]; do
        sleep 1
    done
}
