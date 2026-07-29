FROM node:20-alpine AS base
RUN corepack enable && corepack prepare pnpm@latest --activate
WORKDIR /app

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY packages/shared/package.json ./packages/shared/
COPY apps/api/package.json ./apps/api/
COPY apps/ui/package.json ./apps/ui/

RUN pnpm install --frozen-lockfile --ignore-scripts

COPY . .

ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production

RUN pnpm --filter @voiceplatform/shared build
RUN pnpm --filter @voiceplatform/ui build

EXPOSE 3000

CMD ["pnpm", "--filter", "@voiceplatform/ui", "start", "-p", "3000"]
