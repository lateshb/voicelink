FROM node:20-alpine AS base
RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

# Copy package descriptors
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY packages/shared/package.json ./packages/shared/
COPY apps/api/package.json ./apps/api/
COPY apps/ui/package.json ./apps/ui/

# Install dependencies
RUN pnpm install --frozen-lockfile --ignore-scripts

# Copy source code
COPY . .

# Build shared package and Next.js UI
RUN pnpm --filter @voiceplatform/shared build
RUN pnpm --filter @voiceplatform/ui build

EXPOSE 3000 4000

CMD ["pnpm", "dev"]
