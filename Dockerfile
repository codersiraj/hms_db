# Use Microsoft SQL Server 2022 image
FROM mcr.microsoft.com/mssql/server:2019-latest

# Set environment variables
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=Sirajsql4041!

# Create directory and copy files
WORKDIR /var/opt/mssql/restore
COPY HMS.bak /HMS.bak
COPY entrypoint.sh /entrypoint.sh

# Expose default SQL Server port
EXPOSE 1433

# Run the script
ENTRYPOINT ["/entrypoint.sh"]
