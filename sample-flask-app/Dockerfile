# ---- Build Stage ----
FROM python:3.9-slim AS builder

# Install only needed system deps (and remove after)
RUN apt-get update && apt-get install -y --no-install-recommends gcc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Install dependencies separately to leverage Docker cache
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# ---- Runtime Stage ----
FROM python:3.9-slim

# Set environment variables for Flask in production
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    FLASK_ENV=production

WORKDIR /app

# Copy only installed packages from builder
COPY --from=builder /install /usr/local

# Copy application source code
COPY . .

# Create a non-root user and switch
RUN useradd --create-home --uid 1001 appuser
USER appuser

EXPOSE 5000

# Add healthcheck (using Python instead of curl to avoid extra deps)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s \
  CMD python -c "import requests; exit(0) if requests.get('http://localhost:5000/health').status_code == 200 else exit(1)" || exit 1


CMD ["python", "app.py"]
