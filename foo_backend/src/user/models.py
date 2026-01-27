from tortoise import fields
from tortoise.models import Model
import uuid
from typing import TYPE_CHECKING

# Импортируем модели только для проверки типов IDE, 
# во время выполнения кода этот блок игнорируется.
if TYPE_CHECKING:
    from ..history.models import History
    from ..comments.models import Comment

class User(Model):
    id = fields.UUIDField(pk=True, default=uuid.uuid4)
    username = fields.CharField(max_length=64, null=False, unique=True)
    email = fields.CharField(max_length=64, null=False, unique=True)
    password = fields.CharField(max_length=128, null=False)
    
    theme_mode = fields.CharField(max_length=10, default="system")

    created_at = fields.DatetimeField(auto_now_add=True)

    # Теперь IDE видит типы, а Python не ругается на этапе запуска
    history: fields.ReverseRelation["History"]
    comments: fields.ReverseRelation["Comment"]

    class Meta:
        table = "users"
        ordering = ['username']

    def __str__(self):
        return f"User({self.id} - {self.username})"