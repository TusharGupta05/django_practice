# from django.contrib.auth.backends import ModelBackend
# from .models import MyUser
# from django.contrib.auth.models import User
# from rest_framework.authtoken.models import Token
# from django.contrib.auth import get_user_model

# class CustomAuth(ModelBackend):
#     def authenticate(self, request, email=None, password=None, **kwargs):
#         UserModel = get_user_model()
#         try:
#             user = UserModel.objects.get(email=email)
#             if user.check_password(password):
#                 return user            
#         except:
#             pass
#         return None
    
#     def register(self, request, email, password):
#         user = MyUser.objects.create(email=email, password = password)
#         return user