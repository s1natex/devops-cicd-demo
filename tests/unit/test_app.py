import os
from app.app import app

def test_index_200_and_body():
    c = app.test_client()
    r = c.get("/")
    assert r.status_code == 200
    assert "Hello, World!" in r.get_data(as_text=True)

def test_non_root_user_unit():
    assert os.geteuid() != 0
