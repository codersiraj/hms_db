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

# Stage 2: SQL Server base
FROM mcr.microsoft.com/mssql/server:2019-latest

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=Sirajsql4041!

# Set working directory
WORKDIR /var/opt/mssql/restore

# Copy tools from previous stage
COPY --from=tools /opt/mssql-tools /opt/mssql-tools
COPY --from=tools /usr/bin/sqlcmd /usr/bin/sqlcmd

# Copy backup file and entrypoint
COPY HMS.bak /HMS.bak
COPY entrypoint.sh /entrypoint.sh

# Make the script executable
RUN chmod +x /entrypoint.sh

# Expose SQL Server port
EXPOSE 1433

# Run the script to restore the DB
ENTRYPOINT ["/entrypoint.sh"]
