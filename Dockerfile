# The image we are going to use
FROM elixir:1.14

# Create and set home directory
WORKDIR /app

# Set environment variables for the Elixir application
ENV MIX_ENV=prod

# Install hex package manager
RUN mix local.hex --force

# Install rebar (Erlang build tool)
RUN mix local.rebar --force

# Copy all the files from your host to your current location in the container
COPY . .

# Compile the project
RUN mix do compile

CMD ["mix", "run", "--no-halt"]
