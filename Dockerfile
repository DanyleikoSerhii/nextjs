# Stage 1: Build the application
FROM node:16-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and pnpm-lock.yaml to the working directory
COPY package.json package-lock.json ./

# Install dependencies
# Copy the rest of the application code
COPY . .

# Build the Next.js application
RUN npm install
RUN npm build

# Stage 2: Serve the application
FROM node:16-alpine AS runner

WORKDIR /app

# Copy the built assets from the builder stage
COPY --from=builder /app ./

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
