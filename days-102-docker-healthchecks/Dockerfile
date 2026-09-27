FROM nginx:alpine
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD curl -f http://localhost/ || exit 1
EXPOSE 80
