import pytest
from selenium import webdriver

@pytest.fixture(scope="module")
def selenium_browser(request):
    op = webdriver.ChromeOptions()
    op.add_argument('--no-sandbox')
    op.add_argument('--headless')
    driver = webdriver.Chrome(options=op)
    yield driver
    driver.quit()
