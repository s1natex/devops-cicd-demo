from fastapi.testclient import TestClient

from app.api.api import app

client = TestClient(app)

def test_list_tasks_initially_empty():
    resp = client.get("/tasks")
    assert resp.status_code == 200
    assert resp.json() == []

def test_create_task():
    payload = {"id": 1, "title": "Write tests", "completed": False}
    resp = client.post("/tasks", json=payload)
    assert resp.status_code == 200
    body = resp.json()
    assert body["id"] == 1
    assert body["title"] == "Write tests"
    assert body["completed"] is False

def test_get_task():
    resp = client.get("/tasks/1")
    assert resp.status_code == 200
    assert resp.json()["title"] == "Write tests"

def test_update_task():
    payload = {"id": 1, "title": "Write more tests", "completed": True}
    resp = client.patch("/tasks/1", json=payload)
    assert resp.status_code == 200
    body = resp.json()
    assert body["title"] == "Write more tests"
    assert body["completed"] is True

def test_delete_task():
    resp = client.delete("/tasks/1")
    assert resp.status_code == 200
    assert resp.json()["message"] == "Task deleted"

def test_get_missing_task():
    resp = client.get("/tasks/999")
    assert resp.status_code == 404
    assert resp.json()["detail"] == "Task not found"
