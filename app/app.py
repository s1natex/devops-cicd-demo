from flask import Flask, jsonify
import os, pwd

app = Flask(__name__)

@app.get("/")
def index():
    return "Hello, World!! From ArgoCD sync!, Now it auto updates manifests!!"

@app.get("/healthz")
def healthz():
    return jsonify(status="ok"), 200

@app.get("/whoami")
def whoami():
    uid = os.geteuid()
    return jsonify(uid=uid, user=pwd.getpwuid(uid).pw_name), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
