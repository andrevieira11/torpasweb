# -------- BUILD STAGE --------
FROM node:20-alpine AS builder
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy all source files
COPY . .

# Build production
RUN npm run build

# -------- RUNTIME STAGE --------
FROM node:20-alpine
WORKDIR /app

ENV NODE_ENV=production

# Copy only what is needed for runtime
COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Optional: copy next.config.js if you have custom settings
# COPY --from=builder /app/next.config.js ./next.config.js

EXPOSE 3000
CMD ["npm", "start"]
