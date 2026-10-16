FROM python:3.11-slim

WORKDIR /app

# Install system dependencies if needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Set Python path
ENV PYTHONPATH=/app

# Collect static files at build time
RUN python manage.py collectstatic --noinput

# Expose port
EXPOSE 8000

# Auto-migrate and start Gunicorn
CMD sh -c "python manage.py migrate && gunicorn myapp.wsgi:application --workers 2 --threads 2 --timeout 120 --bind 0.0.0.0:8000"
