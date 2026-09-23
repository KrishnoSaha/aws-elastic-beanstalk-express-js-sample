FROM node:16-alpine
WORKDIR /usr/src/app

# copy package files first so the install layer gets cached
COPY package*.json ./
RUN npm install --omit=dev

COPY . .

# run as the node user, not root
USER node
EXPOSE 8080
CMD ["node", "app.js"]
