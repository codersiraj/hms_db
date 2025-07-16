# Use Microsoft SQL Server 2019
FROM mcr.microsoft.com/mssql/server:2019-latest

# Set environment variables
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=Sirajsql4041!

# Install sqlcmd
RUN apt-get update && \
    apt-get install -y curl gnupg2 apt-transport-https && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev && \
    ln -s /opt/mssql-tools/bin/sqlcmd /usr/bin/sqlcmd

# Copy backup and script
COPY HMS.bak /HMS.bak
COPY entrypoint.sh /entrypoint.sh

# Ensure script is executable
RUN chmod +x /entrypoint.sh

# Expose SQL Server port
EXPOSE 1433

# Start with your script
ENTRYPOINT ["/entrypoint.sh"]