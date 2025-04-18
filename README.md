# Aidify - AI-Based Smart Assistant for Differently-Abled Individuals

Aidify is an AI-powered smart assistant designed to empower differently-abled individuals by enhancing communication, navigation, and independence. Built using Flutter, Aidify leverages machine learning to provide real-time assistance.

## Features

- **AI-Powered Object Detection** - Helps visually impaired users identify objects and navigate safely.
- **Speech-to-Text Transcription** - Converts speech into text for individuals with hearing impairments.
- **Text-to-Speech Synthesis** - Reads out text to assist visually impaired users.
- **AI Voice Assistant** - Hands-free control and interaction using voice commands.
- **Customizable Dark Mode** - Enhances accessibility and reduces eye strain.

## Technology Stack

- **Framework:** Flutter (Dart)
- **Backend:** supabase and django FAST API yolov5
- **APIs & Libraries:** Pre-trained models from Hugging Face
- **Operating System:** Android (API level 21 and above)

## Hardware Requirements

- **Camera** - For object detection
- **Microphone** - For speech recognition
- **Speaker** - For text-to-speech output
## Installation backend

1. Clone the repository:
   ```sh
   git clone https://github.com/your-repo/Aidify.git
   cd backend
   ```
2. Install dependencies:
   ```sh
   pip install -r requirements.txt
   pip install fastapi uvicorn pillow
   pip install python-multipart
   ```
3. Run the server:
   ```sh
   uvicorn app:app --host 0.0.0.0 --port 8000
   ```
## Installation fronend

1. Clone the repository:
   ```sh
   git clone https://github.com/your-repo/Aidify.git
   cd Aidify
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run the app:
   ```sh
   flutter run
   ```

## Purpose and Social Impact

- Enhances independence and inclusivity for differently-abled individuals.
- Bridges communication gaps and fosters social participation.
- Provides an affordable and accessible assistive technology solution.

## Contributors

- Royal Kuriyakose (FIT22CS160)
- Sam Ben Johnson (FIT22CS163)
- Sanjay Njarakkattil (FIT22CS166)
- Noel Benny (FIT22CS147)

## License

This project is licensed under the MIT License.

## Contact

For inquiries and contributions, please contact the project coordinators:
- Dr. Siyamol Chirakkarottu
- Dr. Anil Kumar M N
- Mrs. Anisha Antu
