# Stage 1: Build stage
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY main.go .
RUN go build -o myapp main.go

# Stage 2: Production stage
FROM alpine:3.18
WORKDIR /root/
COPY --from=builder /app/myapp .
CMD ["./myapp"]
