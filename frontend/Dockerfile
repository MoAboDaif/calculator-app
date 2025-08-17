FROM node:current-alpine3.22 AS builder

WORKDIR /app

COPY . .

RUN npm ci
RUN npm run build

FROM nginx:stable-alpine3.21-slim
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD [ "nginx", "-g", deamon off; ]