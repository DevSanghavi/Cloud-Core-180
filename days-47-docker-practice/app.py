import os
from http.server import BaseHTTPRequestHandler, HTTPServer

PORT = 8080
STATUS = os.getenv("HEALTH_STATUS", "ok")

class Handler(BaseHTTPRequestHandler):
  def do_GET(self):
    code = 200 if STATUS == "ok" else 500
    self.send_response(code)
    self.send_header("Content-type", "text/plain")
    self.end_headers()
    self.wfile.write(f"STATUS: {STATUS}\n".encode())

  def log_message(self, format, *args):
    pass

if __name__ == "__main__":
  server = HTTPServer(("0.0.0.0", PORT), Handler)
  server.serve_forever()
