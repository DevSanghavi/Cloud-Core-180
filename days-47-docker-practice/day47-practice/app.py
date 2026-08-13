import os
from http.server import BaseHTTPRequestHandler, HTTPServer

PORT = 8080
SERVICE = os.getenv("SERVICE_NAME", "practice-api")
ENVIRONMENT = os.getenv("ENV", "dev")

class PracticeHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/plain")
        self.end_headers()
        
        # Output format required by the evaluator
        response_text = f"SERVICE_NAME={SERVICE}, ENV={ENVIRONMENT}\n"
        self.wfile.write(response_text.encode())

    def log_message(self, format, *args):
        pass

if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", PORT), PracticeHandler)
    server.serve_forever()
