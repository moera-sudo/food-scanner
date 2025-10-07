from tortoise import fields
from tortoise.models import Model
from tortoise.validators import MinValueValidator, MaxValueValidator

import enum

class NutriScoreEnum(enum.Enum):
    A = 'A'
    B = 'B'
    C = 'C'
    D = 'D'
    E = 'E'



class Product(Model):

    id = fields.IntField(pk=True)
    name = fields.CharField(max_length=64)
    description = fields.TextField()
    
    calories = fields.IntField()
    fat = fields.IntField()
    protein = fields.IntField()
    carbs = fields.IntField()
    sugar = fields.IntField()
    fiber = fields.IntField()

    created_at = fields.DatetimeField(auto_now_add=True)


    rating = fields.FloatField(
        validators=[MinValueValidator(1), MaxValueValidator(10)]
    )
    nutriscore = fields.CharEnumField(NutriScoreEnum)

    image_url = fields.TextField()

    class Meta:
        table = 'products'
        constraints  = [
            "CHECK (rating >= 10 AND rating <= 1 )"
        ]

    def __str__(self):
        return f"Product: {self.id} Name: {self.name} Image_url: {self.image_url}"

        