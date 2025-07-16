# Stage 1: Tools installer
FROM ubuntu:20.04 as tools

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y curl gnupg apt-transport-https software-properties-common && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev && \
    ln -s /opt/mssql-tools/bin/sqlcmd /usr/bin/sqlcmd

# Stage 2: SQL Server image
FROM mcr.microsoft.com/mssql/server:2019-latest

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=Sirajsql4041!

WORKDIR /usr/src/app

# Copy tools from previous stage
COPY --from=tools /opt/mssql-tools /opt/mssql-tools
COPY --from=tools /usr/bin/sqlcmd /usr/bin/sqlcmd

# Copy database and script
COPY HMS.bak ./HMS.bak
COPY entrypoint.sh ./entrypoint.sh

# Do not run chmod on root path
# Just make sure your script has execution permissions from host (use Git or chmod locally)

# Expose SQL Server port
EXPOSE 1433

# Set entrypoint
ENTRYPOINT ["bash", "/usr/src/app/entrypoint.sh"]
