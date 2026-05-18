FROM node:20-alpine

WORKDIR /app

COPY package.json .
RUN npm install --omit=dev

COPY src/ ./src/

ARG APP_VERSION=dev
ENV APP_VERSION=$APP_VERSION

ARG IMAGE_TAG=dev
ENV IMAGE_TAG=$IMAGE_TAG

EXPOSE 3000

CMD ["node", "src/index.js"]
