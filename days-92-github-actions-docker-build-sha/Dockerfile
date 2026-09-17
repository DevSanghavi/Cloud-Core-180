ARG NODE_VERSION=18
FROM node:${NODE_VERSION}-alpine
ARG VERSION
LABEL version=$VERSION
WORKDIR /app
COPY index.js .
CMD ["node","index.js"]
