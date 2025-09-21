from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def index():
    return "Hello, World!"


@app.get("/healthz")
def healthz():
    return jsonify(status="ok"), 200


if __name__ == "__main__":
    app.run(port=8000) # debug=True
