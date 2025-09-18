from pathlib import Path
from bs4 import BeautifulSoup

FRONTEND_FILE = Path("app/frontend/index.html")

def test_frontend_file_exists():
    assert FRONTEND_FILE.exists(), "app/frontend/index.html is missing"

def test_frontend_has_expected_elements():
    html = FRONTEND_FILE.read_text(encoding="utf-8")
    soup = BeautifulSoup(html, "html.parser")
    assert soup.select_one("#add-form") is not None
    assert soup.select_one("#task-input") is not None
    assert soup.select_one("#list") is not None
    assert soup.select_one("#api-base-label") is not None
