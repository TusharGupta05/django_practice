from django.db import models
from django.db.models import fields
from rest_framework.serializers import ModelSerializer
from notes.models import Note


class NoteSerializer(ModelSerializer):
    def create(self, validated_data):
        note = Note.objects.create(**validated_data)
        return note

    class Meta:
        model = Note
        fields = ['title', 'description', 'last_edited', 'user_id', 'id']
