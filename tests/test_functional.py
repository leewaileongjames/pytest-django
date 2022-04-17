import pytest

def test_example(live_server,selenium_browser):
    browser = selenium_browser
    browser.get(("%s%s" % (live_server.url, "/admin/")))
    print(browser.title)
    assert "Django site admin" in browser.title
