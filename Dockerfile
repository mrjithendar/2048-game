FROM node:16
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY 2048-React-CICD-master .
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]
