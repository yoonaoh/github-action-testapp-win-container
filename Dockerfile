# Use Windows Server Core as base image
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Set shell to PowerShell
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Download and install Python
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.9.13/python-3.9.13-amd64.exe -OutFile python-installer.exe ; \
    Start-Process python-installer.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1 Include_test=0' -Wait ; \
    Remove-Item python-installer.exe -Force

# Verify Python installation and upgrade pip
RUN Write-Host 'Verifying Python installation...'; \
    $env:PATH = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine'); \
    python --version; \
    python -m pip install --upgrade pip

# Install Flask
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Set the working directory
WORKDIR /app

# Copy application files
COPY . /app

# Expose port 80
EXPOSE 80

# Set the startup command
CMD ["python", "app.py"]
