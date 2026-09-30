FROM nginx:alpine
# 1. Create a non-root group and user
RUN addgroup -g 1001 appgroup && adduser -u 1001 -G appgroup -D appuser

# 2. Give the non-root user permissions to own necessary Nginx paths
RUN chown -R appuser:appgroup /usr/share/nginx/html && \
    chown -R appuser:appgroup /var/cache/nginx && \
    chown -R appuser:appgroup /var/log/nginx && \
    chown -R appuser:appgroup /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R appuser:appgroup /var/run/nginx.pid

# FIX: Tell Nginx to listen on port 8080 instead of the default port 80
RUN sed -i 's/listen       80;/listen       8080;/g' /etc/nginx/conf.d/default.conf

# 3. Switch the active container user to our non-root user
USER appuser
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
