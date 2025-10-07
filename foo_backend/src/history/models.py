from tortoise import fields, models
from tortoise.models import Model
from datetime import datetime


class History(Model):

    id = fields.IntField(pk=True)
    user = fields.ForeignKeyField("models.User", related_name="history")
    product = fields.ForeignKeyField("models.Product", related_name="history")

    created_at = fields.DatetimeField(auto_now_add=True)

    class Meta:
        table = "user_history"
        ordering = ["-created_at"]
        