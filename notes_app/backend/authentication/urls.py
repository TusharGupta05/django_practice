import imp
from django.contrib import admin
from django.urls import path
from django.urls.conf import include
from rest_framework.authtoken import views
from .views import register
# from reset_password.views import ResetPasswordView

urlpatterns = [
    path('login/', view=views.obtain_auth_token),
    path('register/', view=register),
]
