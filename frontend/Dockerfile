# ---------- Build Stage ----------
FROM node:18-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# ---------- Runtime Stage ----------
FROM nginx:alpine
RUN adduser -D appuser

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
USER appuser
