# MSSQL Docker Setup for Render.com

This repo sets up a Microsoft SQL Server instance using Docker, preloads a `HospitalDB` with a `Patients` table, and is ready for deployment on [Render](https://render.com).

## Deployment Steps

1. Push this repo to GitHub.
2. Go to [Render Dashboard](https://dashboard.render.com).
3. Create a **Web Service** using **Docker**.
4. Use port `1433`.
5. Wait for the build and deploy process to complete.

## Credentials

- **User**: `sa`
- **Password**: `YourStrong!Passw0rd`
- **DB Name**: `HospitalDB`

Use these in your application connection string.