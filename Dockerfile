# Install pnpm globally
FROM node:21-alpine AS builder
WORKDIR /app
COPY package.json pnpm-lock.yaml* ./
RUN corepack enable


RUN --mount=type=secret,id=npmrc,target=/root/.npmrc pnpm fetch --prod --frozen-lockfile
RUN --mount=type=secret,id=npmrc,target=/root/.npmrc pnpm install --prod --frozen-lockfile

# Copy the rest of the application code
COPY . .

# Build the Next.js application
RUN pnpm build

# Use a lighter image for the final build
FROM node:16-alpine AS runner
WORKDIR /app

# Copy the built assets from the builder stage
COPY --from=builder /app ./

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

USER nextjs
ENV HOSTNAME 0.0.0.0
EXPOSE 3000

# Start the application
CMD ["pnpm", "start"]
