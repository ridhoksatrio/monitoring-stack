#!/bin/bash
case "$1" in
  on)
    echo '{"mode":"normal","degraded":["ONT-CUST-003"],"los":[]}' > /tmp/ont_state.json
    echo "$(date -Is) START ftth_degradation ONT-CUST-003" >> ~/noc-p1-monitoring-stack/.local/fault.log ;;
  off)
    echo '{"mode":"normal","degraded":[],"los":[]}' > /tmp/ont_state.json
    echo "$(date -Is) END ftth_degradation" >> ~/noc-p1-monitoring-stack/.local/fault.log ;;
esac
