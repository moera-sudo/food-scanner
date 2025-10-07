from tortoise import fields
from tortoise.models import Model

class Comment(Model):
    id = fields.IntField(pk=True)
    user = fields.ForeignKeyField("models.User", related_name="comments")
    product = fields.ForeignKeyField("models.Product", related_name="comments")
    text = fields.TextField()
    created_at = fields.DatetimeField(auto_now_add=True)

    class Meta:
        table = "product_comments"
        ordering = ["-created_at"]
