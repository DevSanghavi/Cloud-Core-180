FROM python:3.11-alpine
WORKDIR /app
COPY app.py .
ENV HEALTH_STATUS=ok
EXPOSE 8080
CMD ["python", "app.py"]
