# tests/e2e/test_docker.py
import os, subprocess, time, requests

IMAGE = "helloworld:ci"
APP_URL = os.getenv("APP_URL", "http://127.0.0.1:8000")

def run(cmd):
    return subprocess.check_output(cmd, text=True)

def _assert_endpoints():
    r = requests.get(f"{APP_URL}/")
    assert r.status_code == 200 and "Hello, World!" in r.text

    who = requests.get(f"{APP_URL}/whoami").json()
    assert who["uid"] != 0

def test_app_endpoints_and_non_root():
    """Works in two modes:
    1) COMPOSE_E2E=1 -> expect app is already running via docker compose
    2) default -> build and run single container here (original behavior)
    """
    if os.getenv("COMPOSE_E2E") == "1":
        for _ in range(30):
            try:
                _assert_endpoints()
                return
            except Exception:
                time.sleep(1.5)
        raise AssertionError("App not ready under compose")
    else:
        run(["docker", "build", "-t", IMAGE, "app"])
        cid = run(["docker", "run", "-d", "-p", "8000:8000", IMAGE]).strip()
        try:
            for _ in range(30):
                try:
                    _assert_endpoints()
                    return
                except Exception:
                    time.sleep(1)
            raise AssertionError("App not ready in standalone mode")
        finally:
            subprocess.call(["docker", "rm", "-f", cid])
