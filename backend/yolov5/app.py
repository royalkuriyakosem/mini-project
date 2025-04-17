from fastapi import FastAPI, File, UploadFile
import cv2
import numpy as np
import torch
from io import BytesIO
from PIL import Image
import os

app = FastAPI()

# Load YOLOv5 model from Ultralytics with trust_repo=True to avoid Render warnings
model = torch.hub.load("ultralytics/yolov5", "yolov5s", source="github", trust_repo=True)

@app.get("/")
async def root():
    return {"message": "YOLOv5 object detection API is running!"}

@app.post("/detect/")
async def detect_objects(file: UploadFile = File(...)):
    contents = await file.read()
    image = Image.open(BytesIO(contents)).convert("RGB")
    img_np = np.array(image)

    # Run detection
    results = model(img_np)
    detections = results.pandas().xyxy[0].to_dict(orient="records")

    return {"detections": detections}

# Allow Render to bind to the correct port
if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run("app:app", host="0.0.0.0", port=port)
