import pytest
from django.contrib.auth.models import User

@pytest.fixture()
def admin_1(db):
    return User.objects.create_user(
        username='admin1',
        email='admin1@test.com',
        password='password1',
        first_name='John',
        last_name='Doe'
    )

@pytest.mark.django_db
def test_user_database(admin_1):
    assert admin_1.username == "admin1"
    assert admin_1.email == "admin1@test.com"
    assert admin_1.first_name == "John"
    assert admin_1.last_name == "Doe"
