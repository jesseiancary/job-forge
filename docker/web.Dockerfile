FROM node:24

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies. Use `npm ci` (not `npm install`) — it always purges
# node_modules and installs strictly from package-lock.json, which avoids a
# known npm bug where optionalDependencies (e.g. rolldown's platform-specific
# native bindings) are sometimes skipped by npm install's incremental resolver.
# See https://github.com/npm/cli/issues/4828
RUN npm ci

# Expose Vite dev server port
EXPOSE 5173

# Start dev server
CMD ["npm", "run", "dev"]
