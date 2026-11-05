#!/usr/bin/env python3
"""Ansible inventory from Terraform outputs; no fixed node addresses."""
import json
import os
from pathlib import Path
import subprocess
import sys

root = Path(__file__).resolve().parents[2]
env = dict(os.environ, AWS_EC2_METADATA_DISABLED="true")
credentials = root / ".local/backend-credentials.json"
if credentials.exists():
    keys = json.loads(credentials.read_text())
    env.setdefault("AWS_ACCESS_KEY_ID", keys["access_key"])
    env.setdefault("AWS_SECRET_ACCESS_KEY", keys["secret_key"])
nodes = json.loads(subprocess.check_output([
    "terraform", f"-chdir={root / 'terraform/main'}", "output", "-json", "nodes",
], env=env))
hostvars = {name: {
    "ansible_host": node["public_ip"],
    "ansible_user": node["user"],
    "node_ip": node["private_ip"],
} for name, node in nodes.items()}
inventory = {
    "_meta": {"hostvars": hostvars},
    "control_plane": {"hosts": ["control"]},
    "workers": {"hosts": [name for name in nodes if name != "control"]},
    "k8s_cluster": {"children": ["control_plane", "workers"]},
}
print(json.dumps(hostvars.get(sys.argv[2], {}) if len(sys.argv) > 2 and sys.argv[1] == "--host" else inventory))
