import subprocess, time, requests, json

IMAGE = "helloworld:ci"

def run(cmd):
    return subprocess.check_output(cmd, text=True)

def test_docker_container_endpoints_and_non_root():
    run(["docker","build","-t",IMAGE,"app"])
    cid = run(["docker","run","-d","-p","8000:8000",IMAGE]).strip()
    try:
        time.sleep(2)
        r = requests.get("http://127.0.0.1:8000/")
        assert r.status_code == 200 and "Hello, World!" in r.text
        who = requests.get("http://127.0.0.1:8000/whoami").json()
        assert who["uid"] != 0
    finally:
        subprocess.call(["docker","rm","-f",cid])
