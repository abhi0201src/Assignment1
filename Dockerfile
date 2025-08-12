# Dockerfile for Django + DRF backend
FROM python:3.11-slim AS builder

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on

# Set work directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt


# Final stage
FROM python:3.11-slim

# Create non-root user
RUN useradd -m appuser && \
    mkdir -p /app && \
    chown appuser:appuser /app

# Set work directory
WORKDIR /app

# Copy dependencies from builder
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

# Copy project files
COPY --chown=appuser:appuser . .

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health/ || exit 1

# Run migrations and start server with Gunicorn
CMD ["sh", "-c", "python manage.py migrate && gunicorn RestaurantCore.wsgi:application --bind 0.0.0.0:8000 --workers 4 --worker-class=gthread --threads=2 --timeout=30"]
