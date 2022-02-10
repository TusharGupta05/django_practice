from curses import noraw
from rest_framework import serializers
from rest_framework.authentication import SessionAuthentication, BasicAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.status import HTTP_200_OK, HTTP_201_CREATED, HTTP_202_ACCEPTED, HTTP_400_BAD_REQUEST, HTTP_404_NOT_FOUND
from notes.models import Note
from notes.serializer import NoteSerializer
from rest_framework.views import APIView
from rest_framework.authentication import TokenAuthentication


class NotesView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    model = Note
    serializer_class = NoteSerializer

    def get(self, request, note_id):
        try:
            note = Note.objects.get(pk=note_id, user_id=request.user.id)
            return Response(NoteSerializer(note).data)
        except Note.DoesNotExist:
            return Response(status=HTTP_404_NOT_FOUND)

    def put(self, request, note_id):
        print(request)
        try:
            note = Note.objects.get(pk=note_id, user_id=request.user.id)
            new_note = NoteSerializer(note).data
            data = request.data
            fields = ['title', 'description']
            for field in fields:
                if data.get(field) is not None:
                    new_note[field] = data.get(field)
            serializer = NoteSerializer(note, data=new_note)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=HTTP_200_OK)
            return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)
        except Note.DoesNotExist:
            return Response(status=HTTP_404_NOT_FOUND)

    def delete(self, request, note_id):
        try:
            note = Note.objects.get(pk=note_id, user_id=request.user.id)
            note.delete()
            return Response(status=HTTP_202_ACCEPTED)
        except Note.DoesNotExist:
            return Response(status=HTTP_404_NOT_FOUND)


class NotesList(APIView):
    model = Note
    serializer_class = NoteSerializer

    def get(self, request):
        notes = Note.objects.filter(user_id=request.user.id)
        notes_serializer = NoteSerializer(notes, many=True)
        return Response(notes_serializer.data)

    def post(self, request):
        data = request.data.copy()
        data['user_id'] = request.user.id
        serializer = NoteSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=HTTP_201_CREATED)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)
