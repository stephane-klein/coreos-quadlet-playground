# Function that waits for SSH service to be available
# Usage:
#
#   source scripts/_utils.sh
#
#   wait_for_ssh_availability "127.0.0.1" 2222 "stephane"

wait_for_ssh_availability() {
    local host="$1"
    local port="$2"
    local user="$3"
    local max_attempts=60  # Maximum 5 minutes (60 * 5 seconds)

    echo "  Waiting for SSH service to be available on $host:$port..."

    local attempt=1
    while true; do
        if ssh -p "$port" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=5 -o BatchMode=yes "$user@$host" exit 2>/dev/null; then
            echo "  ✅ SSH service is up on $host:$port!"
            return 0
        fi

        if [ $attempt -ge $max_attempts ]; then
            echo "  ❌ Timeout waiting for SSH service on $host:$port"
            return 1
        fi

        echo "  Waiting for SSH (attempt $attempt/$max_attempts)..."
        attempt=$((attempt + 1))
        sleep 5
    done
}
