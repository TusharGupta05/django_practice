from django.db import models
from django.contrib.auth import get_user_model

from authentication.models import User


class Note(models.Model):
    id = models.AutoField(primary_key=True)
    title = models.TextField(null=False)
    description = models.TextField(null=False)
    last_edited = models.DateTimeField(auto_now=True)
    user_id = models.ForeignKey(get_user_model(), on_delete=models.CASCADE)

    def __str__(self):
        return self.title

    class Meta:
        db_table = 'notes'
        ordering = ['-last_edited']
