FROM node:18-alpine
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm install && npm install -g serve
COPY . .
RUN npm run build
EXPOSE 3001
CMD ["serve", "-s", "build"]
