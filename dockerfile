# Start with an Elixir base image
FROM elixir:1.13-alpine AS build

# Install dependencies
RUN apk add --no-cache build-base npm git

# Set working directory
WORKDIR /app

# Install Elixir and Node.js dependencies
COPY mix.exs mix.lock ./
RUN mix do local.hex --force, local.rebar --force
RUN mix deps.get

COPY assets/package.json assets/package-lock.json ./assets/
RUN npm install --prefix ./assets

# Copy the rest of the app
COPY . .

# Build the Phoenix application
RUN mix assets.deploy
RUN mix do compile, phx.digest

# Expose port 4000 to the outside world
EXPOSE 4000

# Start the Phoenix server
CMD ["mix", "phx.server"]
