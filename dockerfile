# Stage 1: build
FROM node:18-alpine AS build

WORKDIR /app

# Copy package.json and install only production deps
COPY package.json package-lock.json* ./
RUN npm ci --only=production

# Copy source code
COPY index.js ./

# Stage 2: runtime
FROM node:18-alpine

WORKDIR /app

# Copy only production dependencies and app code
COPY --from=build /app /app

# Expose port
EXPOSE 3000

# Start the app
CMD ["npm", "run","start"]
