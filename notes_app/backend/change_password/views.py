
from urllib.parse import urlencode
from django.core.mail import EmailMessage
from django.shortcuts import render
from django.utils import timezone
from rest_framework.response import Response
from rest_framework.decorators import permission_classes, authentication_classes, api_view
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from django.contrib.auth import get_user_model
from rest_framework.status import HTTP_200_OK, HTTP_201_CREATED, HTTP_202_ACCEPTED, HTTP_400_BAD_REQUEST, HTTP_404_NOT_FOUND
from django.contrib.auth.tokens import PasswordResetTokenGenerator

from notes_app.settings import BASE_DIR, BASE_URL


@api_view(['POST'])
@authentication_classes([])
@permission_classes([AllowAny])
def forgot_password(request):
    try:
        user = get_user_model().objects.get(email=request.data.get('email'))
    except:
        return Response(status=HTTP_404_NOT_FOUND, data={'msg': "User doesn't exist."})
    token = PasswordResetTokenGenerator().make_token(user=user)
    print(token)
    msg = EmailMessage(
        subject='Reset Password',
        body='Please click on the following link to reset your password: ' +
        '{}/help/reset-password/?'.format(BASE_URL) +
        urlencode(query={'email': user.email, 'token': token}),
        to=[user.email]
    )
    print(msg.body)
    msg.send()
    return Response(status=HTTP_200_OK, data={'msg': 'Email sent.'})


@api_view(['GET', 'POST'])
@authentication_classes([])
@permission_classes([AllowAny])
def reset_password(request):
    token = request.query_params.get('token')
    email = request.query_params.get('email')
    try:
        user = get_user_model().objects.get(email=email)
    except:
        return Response(status=HTTP_404_NOT_FOUND)
    if request.method == 'GET':
        if token is not None:
            if PasswordResetTokenGenerator().check_token(token=token, user=user):
                return render(request=request, template_name='index.html')
        return Response(status=HTTP_400_BAD_REQUEST, data={'msg': 'token expired.'})
    else:
        if token is not None:
            if PasswordResetTokenGenerator().check_token(token=token, user=user):
                password1 = request.data.get('password1')
                password2 = request.data.get('password2')
                if password1 == password2:
                    user.set_password(password1)
                    user.last_login = timezone.now()
                    user.save()
                    return Response(status=HTTP_202_ACCEPTED)
                return Response(exception=True, status=HTTP_400_BAD_REQUEST)
            return Response(status=HTTP_400_BAD_REQUEST, data={'msg': 'token expired.'})


@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def change_password(request):
    user = request.user
    print(user)
    user_model = get_user_model()
    old_password = request.data.get('old_password')
    new_password = request.data.get('new_password')
    if user.check_password(old_password):
        user.set_password(new_password)
        user.save()
        return Response(status=HTTP_200_OK, data={'msg': 'password reset successfully.'})
    else:
        return Response(status=HTTP_400_BAD_REQUEST, data={'msg': 'Incorrect old password.'})
