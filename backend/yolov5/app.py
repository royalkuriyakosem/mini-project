from fastapi import FastAPI, File, UploadFile
import cv2
import numpy as np
import torch
from io import BytesIO
from PIL import Image

# Load YOLOv5 model
model = torch.hub.load("ultralytics/yolov5", "yolov5s", source="github")

app = FastAPI()

@app.post("/detect/")
async def detect_objects(file: UploadFile = File(...)):
    contents = await file.read()
    image = Image.open(BytesIO(contents)).convert("RGB")
    img_np = np.array(image)

    # Run YOLOv5 detection
    results = model(img_np)
    detections = results.pandas().xyxy[0].to_dict(orient="records")

    return {"detections": detections}
