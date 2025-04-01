FROM mcr.microsoft.com/dotnet/runtime:7.0

ENV STABLE_URL="https://cdn.vintagestory.at/gamefiles/stable/vs_server_linux-x64_"
ENV UNSTABLE_URL="https://cdn.vintagestory.at/gamefiles/unstable/vs_server_linux-x64_"


# Install required packages
RUN apt-get update && apt-get install -y \
    wget jq procps screen\
    && rm -rf /var/lib/apt/lists/*

# Create non-root user and group with specific IDs
RUN useradd -u 1000 vintagestory -s /sbin/nologin -m

# Create necessary directories
RUN mkdir -p /home/vintagestory/server \
    /var/vintagestory/data

# Set ownership
WORKDIR /home/vintagestory/server

# Copy scripts into the container
COPY scripts/download_server.sh /home/vintagestory/server/
COPY scripts/check_and_start.sh /home/vintagestory/server/

# Make scripts executable and set ownership
RUN chmod +x /home/vintagestory/server/*.sh && \
    chown vintagestory:vintagestory -R /home/vintagestory && \
    chown vintagestory:vintagestory -R /var/vintagestory/data

USER vintagestory

EXPOSE 42420

ENTRYPOINT ["/home/vintagestory/server/check_and_start.sh"]
