import torch
import torch.nn as nn
from torchvision import models, transforms
from PIL import Image
from io import BytesIO
import numpy as np
import logging

logger = logging.getLogger(__name__)

class FeatureExtractor:
    _instance = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(FeatureExtractor, cls).__new__(cls)
            cls._instance._load_model()
        return cls._instance

    def _load_model(self):
        logger.info("Loading ML model for image search...")
        # Используем MobileNet_V2, предобученную на ImageNet
        # weights='DEFAULT' загружает веса
        self.model = models.mobilenet_v2(weights=models.MobileNet_V2_Weights.DEFAULT)
        
        # Нам не нужен последний слой (классификатор), нам нужны признаки
        # Заменяем классификатор на "пустышку", чтобы получить вектор признаков (1280 чисел)
        self.model.classifier = nn.Identity()
        
        self.model.eval() # Режим оценки (не обучение)

        # Стандартные преобразования для нейросетей
        self.preprocess = transforms.Compose([
            transforms.Resize(256),
            transforms.CenterCrop(224),
            transforms.ToTensor(),
            transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
        ])
        logger.info("ML model loaded successfully.")

    def get_vector(self, image_bytes: bytes) -> list[float]:
        try:
            img = Image.open(BytesIO(image_bytes)).convert('RGB')
            img_tensor = self.preprocess(img)
            img_tensor = img_tensor.unsqueeze(0) # Добавляем batch dimension

            with torch.no_grad():
                vector = self.model(img_tensor)
            
            # Превращаем тензор в плоский список python float
            return vector.flatten().tolist()
        except Exception as e:
            logger.error(f"Error generating vector: {e}")
            return []

ml_extractor = FeatureExtractor()