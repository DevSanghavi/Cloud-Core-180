#!/usr/bin/env bash
set -euo pipefail

# Basic config (edit for your environment)
OUTDIR="$HOME/cloud-practice/incidents"
REMOTE_USER="remote_user"          # change when using remote upload
REMOTE_HOST=""     # change or leave empty to skip upload
REMOTE_PATH="/var/pcap-archive"    # remote target path
CAPTURE_IF="lo"                    # interface to capture (adjust)
BPF_FILTER="tcp and (port 8081 or port 8082)"  # adjust filter to scope
CAPTURE_SECONDS=15
SNAPLEN=262144
MAX_PACKETS=1000
KEEP_TCPFLOW=true                  # set true to run tcpflow after capture

# Timestamped incident id
INC_TS=$(date +%s.%N)
INC_DIR="$OUTDIR/incident-$INC_TS"
mkdir -p "$INC_DIR"

# 1) Pre-snapshot
echo "$INC_TS: pre-snapshot" > "$INC_DIR/README.txt"
sudo ss -tunap > "$INC_DIR/ss-before.txt" 2>/dev/null || true
sudo lsof -i -n -P > "$INC_DIR/lsof-before.txt" 2>/dev/null || true
sudo conntrack -L > "$INC_DIR/conntrack-before.txt" 2>/dev/null || true

# 2) Capture (bounded)
PCAP_FILE="$INC_DIR/capture.pcap"
sudo timeout "$CAPTURE_SECONDS" tcpdump -i "$CAPTURE_IF" -nn -s "$SNAPLEN" -c "$MAX_PACKETS" -w "$PCAP_FILE" "$BPF_FILTER" || true

# 3) Post-snapshot
sudo ss -tunap > "$INC_DIR/ss-after.txt" 2>/dev/null || true
sudo lsof -i -n -P > "$INC_DIR/lsof-after.txt" 2>/dev/null || true
sudo conntrack -L > "$INC_DIR/conntrack-after.txt" 2>/dev/null || true

# 4) Optional tcpflow reassembly (scoped)
if [ "$KEEP_TCPFLOW" = true ]; then
  mkdir -p "$INC_DIR/tcpflow_out"
  sudo tcpflow -r "$PCAP_FILE" -o "$INC_DIR/tcpflow_out/"
  sudo chown -R "$(whoami):$(id -gn)" "$INC_DIR/tcpflow_out"
fi

# 5) Permission normalization and metadata
sudo chown -R "$(whoami):$(id -gn)" "$INC_DIR"
echo "incident_id,$INC_TS" > "$INC_DIR/metadata.csv"
echo "bpf_filter,$BPF_FILTER" >> "$INC_DIR/metadata.csv"
echo "capture_if,$CAPTURE_IF" >> "$INC_DIR/metadata.csv"
echo "snaplen,$SNAPLEN" >> "$INC_DIR/metadata.csv"
echo "max_packets,$MAX_PACKETS" >> "$INC_DIR/metadata.csv"

# 6) Compress artifacts
tar -C "$OUTDIR" -czf "$OUTDIR/incident-$INC_TS.tar.gz" "incident-$INC_TS"
SHA256SUM=$(sha256sum "$OUTDIR/incident-$INC_TS.tar.gz" | awk '{print $1}')
echo "$SHA256SUM  incident-$INC_TS.tar.gz" > "$OUTDIR/incident-$INC_TS.sha256"

# 7) Print artifact locations
echo "Artifacts: $OUTDIR/incident-$INC_TS/ and $OUTDIR/incident-$INC_TS.tar.gz"
echo "SHA256: $SHA256SUM"
