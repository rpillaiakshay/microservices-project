FROM node:14-alpine

WORKDIR /app

# Copy and install dependencies
COPY package*.json ./
RUN npm install

# Copy the application code
COPY . .

# Copy environment variables configuration (if you have a .env file)
COPY .env .env

# Use environment variables (e.g. NODE_ENV) for flexibility
CMD ["node", "server.js"]
