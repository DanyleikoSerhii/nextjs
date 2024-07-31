# Install pnpm globally
FROM node:21-alpine AS builder
RUN npm install -g pnpm@latest

# Set working directory
WORKDIR /app

# Copy package.json and pnpm-lock.yaml to the working directory
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy the rest of the application code
COPY . .

# Build the Next.js application
RUN pnpm build

# Use a lighter image for the final build
FROM node:16-alpine AS runner
WORKDIR /app

# Copy the built assets from the builder stage
COPY --from=builder /app ./

# Expose port
EXPOSE 3000

# Start the application
CMD ["pnpm", "start"]
