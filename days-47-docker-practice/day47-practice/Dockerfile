FROM python:3.11-alpine
WORKDIR /app
COPY app.py .
ENV SERVICE_NAME=practice-api
ENV ENV=dev
EXPOSE 8080
CMD ["python", "app.py"]
