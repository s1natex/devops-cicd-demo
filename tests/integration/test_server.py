import subprocess, time, requests, os, signal

def test_live_server_200s_and_non_root():
    p = subprocess.Popen(["python","app/app.py"])
    try:
        time.sleep(1.5)
        r = requests.get("http://127.0.0.1:8000/")
        assert r.status_code == 200
        assert "Hello, World!" in r.text
        who = requests.get("http://127.0.0.1:8000/whoami").json()
        assert who["uid"] != 0
    finally:
        os.kill(p.pid, signal.SIGTERM)
