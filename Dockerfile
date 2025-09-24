FROM nginx:alpine

# Create custom nginx config for port 3003
RUN echo 'server { \
    listen 3003; \
    listen [::]:3003; \
    server_name localhost; \
    root /usr/share/nginx/html; \
    index index.html; \
    location / { \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

# Copy application files
COPY . /usr/share/nginx/html

# Expose port 3003
EXPOSE 3003

# Start nginx
CMD ["nginx", "-g", "daemon off;"]