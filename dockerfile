# Use a small Node.js base image
FROM node:18-alpine

WORKDIR /app

# Copy package.json if you have dependencies
COPY package*.json ./
RUN npm install --only=production || true

# Copy app source
COPY . .

# Run as non-root user (comes with node:alpine)
USER node

EXPOSE 3000
ENV NODE_ENV=production

# Start the app
CMD ["node", "index.js"]
