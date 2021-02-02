FROM node:14.15.4-alpine AS builder

ENV NODE_ENV=production
ENV APP_ROOT /var/www

WORKDIR $APP_ROOT
COPY . .
COPY --from=deps $APP_ROOT/node_modules ./node_modules
RUN yarn build

# Production image, copy all the files and run next
FROM node:lts-alpine AS runner

WORKDIR $APP_ROOT
ENV NODE_ENV=production
COPY --from=builder $APP_ROOT/next.config.js ./
COPY --from=builder $APP_ROOT/public ./public
COPY --from=builder $APP_ROOT/.next ./.next
COPY --from=builder $APP_ROOT/node_modules ./node_modules
CMD ["node_modules/.bin/next", "start"]