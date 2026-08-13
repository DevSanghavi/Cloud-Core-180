import os
import sys

status = os.getenv("HEALTH_STATUS", "ok")
print(f"STATUS: {status}")

if status != "ok":
    sys.exit(1)
