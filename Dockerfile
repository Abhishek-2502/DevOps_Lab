# Use official Python image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy project files
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Expose Flask port
EXPOSE 5000

# Command to run the app
CMD ["python", "app.py"]


# Build the image
# docker build -t hello-flask .

# Run the container
# docker run -d -p 5000:5000 hello-flask
