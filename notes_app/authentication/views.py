import email
from django.contrib.auth.models import User
from django.shortcuts import render
from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework import serializers, status
from rest_framework.response import Response
from django.contrib.auth import authenticate, login, logout
from rest_framework.authtoken.models import Token
from django.contrib.auth import get_user_model
from authentication.serializers import UserSerializer
from rest_framework.permissions import AllowAny


@api_view(['POST'])
@authentication_classes([])
@permission_classes([AllowAny])
def register(request):
    data = request.data
    serializer = UserSerializer(data=data)
    if serializer.is_valid():
        user = serializer.save()
        model = get_user_model()
        return Response(
            status=status.HTTP_201_CREATED,
            data={
                'token': Token.objects.create(
                    user=model.objects.get(email=user)).key
            }
        )
    return Response(status=status.HTTP_400_BAD_REQUEST, data=serializer.errors)
