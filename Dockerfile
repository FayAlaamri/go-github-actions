# Stage 1: Build the Go application
FROM golang:1.18-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files to download dependencies first (to cache them)
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the rest of the application source code to the container
COPY . .

# Build the Go application
RUN go build -o main .

# Stage 2: Create a lightweight image with the compiled binary
FROM alpine:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the binary from the build stage to the runtime stage
COPY --from=build /app/main .

# Expose port 8080 for the app (if needed, or adjust to your app)
EXPOSE 8080

# Run the binary
CMD ["./main"]
