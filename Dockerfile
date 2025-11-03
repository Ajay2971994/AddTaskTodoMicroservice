# Use the official Python image as the base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the application files into the container
COPY . .

# Install necessary packages
RUN apt-get update && apt-get install -y unixodbc unixodbc-dev
# 5️⃣ Add Microsoft's official GPG key (apt-key deprecated, so use gpg --dearmor)
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg

# 6️⃣ Add Microsoft’s Debian 12 (Bookworm) repository (for SQL driver)
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" \
    > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17

RUN pip install -r requirements.txt

# Start the FastAPI application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
#CMD uvicorn app:app --host 0.0.0.0 --port 8000