# Stage 1: Install tools in a separate build stage
FROM ubuntu:20.04 as tools

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y curl gnupg apt-transport-https software-properties-common && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev && \
    ln -s /opt/mssql-tools/bin/sqlcmd /usr/bin/sqlcmd

# Stage 2: SQL Server base
FROM mcr.microsoft.com/mssql/server:2019-latest

# Set environment variables
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=Sirajsql4041!

# Set working directory
WORKDIR /usr/src/app

# Copy tools from build stage
COPY --from=tools /opt/mssql-tools /opt/mssql-tools
COPY --from=tools /usr/bin/sqlcmd /usr/bin/sqlcmd

# Copy DB backup and startup script
COPY HMS.bak ./HMS.bak
COPY entrypoint.sh ./entrypoint.sh

# Ensure entrypoint script is executable (locally, or do it here if needed)
RUN chmod +x ./entrypoint.sh

# Expose SQL Server port
EXPOSE 1433

# Set entrypoint
ENTRYPOINT ["bash", "./entrypoint.sh"]
