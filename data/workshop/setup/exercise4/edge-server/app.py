import os
import redis
from flask import Flask, request, jsonify
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

BROKER_HOST = os.getenv("BROKER_HOST", "message-broker")
BROKER_PORT = int(os.getenv("BROKER_PORT", 6379))
BROKER_CHANNEL = os.getenv("BROKER_CHANNEL", "socketio")

r = redis.Redis(host=BROKER_HOST, port=BROKER_PORT)
r.ping()
logger.info(f"Connected to message broker at {BROKER_HOST}:{BROKER_PORT}")


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "healthy", "broker": "connected" if r.ping() else "down"})


@app.route("/webhook", methods=["POST"])
def webhook():
    payload_data = request.get_data()
    subscribers = r.publish(BROKER_CHANNEL, payload_data)
    logger.info(f"Published {len(payload_data)} bytes to '{BROKER_CHANNEL}', {subscribers} subscriber(s)")
    return jsonify({"status": "ok", "subscribers": subscribers, "size": len(payload_data)})


if __name__ == "__main__":
    host = os.getenv("FLASK_HOST", "0.0.0.0")
    port = int(os.getenv("FLASK_PORT", 6000))
    logger.info(f"Edge server on {host}:{port}, channel={BROKER_CHANNEL}")
    app.run(host=host, port=port)
