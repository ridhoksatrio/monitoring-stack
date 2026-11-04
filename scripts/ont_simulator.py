#!/usr/bin/env python3
import json, random, subprocess, time, pathlib
ZBX_SERVER = "127.0.0.1"
STATE_FILE = pathlib.Path("/tmp/ont_state.json")
ONTS = [f"ONT-CUST-{i:03d}" for i in range(1, 6)]
OLT = "OLT-SIM-01"
INTERVAL = 30
def load_state():
    default = {"mode": "normal", "degraded": [], "los": []}
    try: return json.loads(STATE_FILE.read_text())
    except: return default
def send(host, key, value):
    subprocess.run(["zabbix_sender", "-z", ZBX_SERVER, "-s", host, "-k", key, "-o", str(value)], capture_output=True, check=False)
def main():
    while True:
        st = load_state()
        online = 0
        for ont in ONTS:
            if st.get("mode") == "pon_los" or ont in st.get("los", []):
                send(ont, "ont.status", 0)
                send(ont, "ont.rx_power", -40.0)
                continue
            base = -31.5 if ont in st.get("degraded", []) else random.uniform(-21, -18)
            send(ont, "ont.status", 1)
            send(ont, "ont.rx_power", round(base + random.uniform(-0.3, 0.3), 2))
            online += 1
        send(OLT, "pon.ont_online[1]", online)
        send(OLT, "pon.ont_total[1]", len(ONTS))
        time.sleep(INTERVAL)
if __name__ == "__main__": main()
