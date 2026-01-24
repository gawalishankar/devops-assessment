# ---------- Build Stage ----------
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# ---------- Runtime Stage ----------
FROM nginx:alpine

# Create non-root user
RUN adduser -D appuser

# Create required nginx directories and set ownership
RUN mkdir -p /var/cache/nginx/client_temp \
    /var/cache/nginx/proxy_temp \
    /var/cache/nginx/fastcgi_temp \
    /var/cache/nginx/uwsgi_temp \
    /var/cache/nginx/scgi_temp \
    /var/run/nginx \
    && chown -R appuser:appuser /var/cache/nginx /var/run/nginx /usr/share/nginx/html

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Copy frontend build
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy custom nginx config
# COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY nginx-main.conf /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

USER appuser

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
