#!/bin/bash
case "$1" in
  on)
    echo '{"mode":"pon_los","degraded":[],"los":[]}' > /tmp/ont_state.json
    echo "$(date -Is) START ftth_los" >> ~/noc-p1-monitoring-stack/.local/fault.log ;;
  off)
    echo '{"mode":"normal","degraded":[],"los":[]}' > /tmp/ont_state.json
    echo "$(date -Is) END ftth_los" >> ~/noc-p1-monitoring-stack/.local/fault.log ;;
esac
