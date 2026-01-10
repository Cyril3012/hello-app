# Build stage
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json .
RUN npm install --only=production
COPY index.js .

# Runtime stage
FROM gcr.io/distroless/nodejs20-debian12
WORKDIR /app
COPY --from=builder /app /app
USER nonroot
EXPOSE 3000
CMD ["index.js"]
