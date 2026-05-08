from flask import Flask, Response
from prometheus_client import Counter, generate_latest
import socket
import datetime

app = Flask(__name__)

REQUEST_COUNT = Counter(
    'app_requests_total',
    'Total App HTTP Request Count'
)

@app.route("/")
def home():
    REQUEST_COUNT.inc()

    return {
        "message": "SRE Project Running",
        "message": "SRE Project Running",
        "pod": socket.gethostname()
    }

@app.route("/health")
def health():
    REQUEST_COUNT.inc()

    return {
        "status": "healthy"
    }

@app.route("/metrics")
def metrics():
    return Response(generate_latest(), mimetype="text/plain")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)