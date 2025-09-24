# ===== Stage 1: Build =====
FROM node:18-alpine AS build

WORKDIR /app

# Copy dependencies first for caching
COPY package.json package-lock.json* ./
RUN npm ci --only=production

# Copy all source files after dependencies
COPY . .

# ===== Stage 2: Runtime =====
FROM node:18-alpine

WORKDIR /app

# Copy everything from build stage
COPY --from=build /app /app

# Expose port
EXPOSE 3000

# Start the app
CMD ["node", "index.js"]
