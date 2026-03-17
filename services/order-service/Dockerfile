# Image de base
FROM node:20-alpine AS base
WORKDIR /app

# Installation des dépendances
FROM base AS deps
COPY package*.json ./
RUN npm ci

# Environnement de développement
FROM deps AS dev
ENV NODE_ENV=development
COPY . .
EXPOSE 3002
CMD ["npm", "run", "dev"]

# Dépendances de production
FROM base AS prod-deps
COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

# Image de production finale
FROM base AS prod
ENV NODE_ENV=production
COPY --from=prod-deps /app/node_modules /app/node_modules
COPY . .
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
EXPOSE 3002
CMD ["npm", "start"]