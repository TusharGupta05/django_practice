from .models import User
from django.db import models
from rest_framework import serializers
from django.contrib.auth import get_user_model
from django.contrib.auth.hashers import make_password


class UserSerializer(serializers.ModelSerializer):

    def create(self, validated_data):
        validated_data['password'] = make_password(
            validated_data.get('password'))
        # print()
        return super(UserSerializer, self).create(validated_data)

    class Meta:
        model = User
        # extra_kwargs = {'password': {'write_only': True}}
        fields = ['email', 'password']
