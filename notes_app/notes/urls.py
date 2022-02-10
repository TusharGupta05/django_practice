from urllib import request
from django.urls.conf import path

from notes.views import NotesList, NotesView


urlpatterns = [
    path('', view=NotesList.as_view()),
    path('<int:note_id>', view=NotesView.as_view())
]
