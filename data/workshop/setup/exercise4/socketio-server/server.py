import os
import socketio
from aiohttp import web
import logging

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
logger = logging.getLogger(__name__)

BROKER_HOST = os.environ.get("BROKER_HOST", "message-broker")
BROKER_PORT = int(os.environ.get("BROKER_PORT", 6379))
SOCKETIO_PORT = int(os.environ.get("SOCKETIO_PORT", 5000))

sio = socketio.AsyncServer(
    async_mode="aiohttp",
    client_manager=socketio.AsyncRedisManager(f"redis://{BROKER_HOST}:{BROKER_PORT}"),
    cors_allowed_origins="*",
)

app = web.Application()
sio.attach(app)


@sio.event
async def connect(sid, environ, auth):
    logger.info(f"Client {sid} connected")
    await sio.emit("welcome", {"message": "Connected to Socket.IO server"}, room=sid)


@sio.event
async def message(sid, data):
    logger.info(f"Message from {sid}: {data}")
    await sio.emit("broadcast", {"data": data, "from": sid})


@sio.event
async def disconnect(sid):
    logger.info(f"Client {sid} disconnected")


async def health(request):
    return web.json_response({"status": "healthy"})


async def index(request):
    return web.Response(
        text="Socket.IO server is running. Connect via a Socket.IO client.",
        content_type="text/plain",
    )


app.router.add_get("/", index)
app.router.add_get("/health", health)

if __name__ == "__main__":
    logger.info(f"Starting Socket.IO server on :{SOCKETIO_PORT}")
    logger.info(f"Message broker: {BROKER_HOST}:{BROKER_PORT}")
    web.run_app(app, host="0.0.0.0", port=SOCKETIO_PORT)
