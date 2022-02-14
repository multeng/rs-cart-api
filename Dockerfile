FROM node:14-alpine as BASE
WORKDIR /app

COPY package*.json ./
RUN npm install

WORKDIR /app
COPY . .
RUN npm run build

FROM node:14-alpine AS release

COPY --from=base /app/package*.json ./
RUN npm install --only=production
COPY --from=base /app/dist ./dist

USER node
ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/main.js"]