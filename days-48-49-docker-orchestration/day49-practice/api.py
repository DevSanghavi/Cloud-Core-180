import os
from http.server import BaseHTTPRequestHandler, HTTPServer

PORT = 8080
SERVICE_NAME = os.getenv("SERVICE_NAME", "compose-api")
ENVIRONMENT = os.getenv("ENVIRONMENT", "dev")
DATA_FILE = "/shared/status.txt"

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        try:
            with open(DATA_FILE, "r") as file:
                records = file.read()
        except FileNotFoundError:
            records = "No worker records yet\n"

        body = (
            f"SERVICE_NAME={SERVICE_NAME}\n"
            f"ENVIRONMENT={ENVIRONMENT}\n"
            f"WORKER_DATA:\n{records}"
        )

        self.send_response(200)
        self.send_header("Content-Type", "text/plain")
        self.end_headers()
        self.wfile.write(body.encode())

    def log_message(self, format, *args):
        pass

server = HTTPServer(("0.0.0.0", PORT), Handler)
server.serve_forever()
