from tortoise import fields
from tortoise.models import Model

import uuid

class User(Model):
    id = fields.UUIDField(pk=True, default=uuid.uuid4)
    username = fields.CharField(max_length=64, null=False, unique=True)
    email = fields.CharField(max_length=64, null=False, unique=True)
    password = fields.CharField(max_length=128, null=False)
    created_at = fields.DatetimeField(auto_now_add=True)

    class Meta:
        table = "users"
        ordering = ['username']

    def __str__(self):
        return f"User({self.id} - {self.username})"
