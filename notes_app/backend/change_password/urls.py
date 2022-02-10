import imp
from django.contrib import admin
from django.urls import path
from django.urls.conf import include
from rest_framework.authtoken import views
from .views import change_password, forgot_password, reset_password

urlpatterns = [
    path('forgot-password/', view=forgot_password),
    path('reset-password/', view=reset_password),
    path('change-password/', view=change_password),
]
