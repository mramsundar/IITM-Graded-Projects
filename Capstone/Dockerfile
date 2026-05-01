# ---------------------------------------------------------------------------
# Healthcare ML Prediction API
# ---------------------------------------------------------------------------
# Build:  docker build -t healthcare-ml-api .
# Run:    docker run -p 8000:8000 healthcare-ml-api
# ---------------------------------------------------------------------------

FROM python:3.11-slim

# libgomp1  — required by LightGBM / XGBoost (used internally by PyCaret)
# build-essential — needed by some Python packages that compile C extensions
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libgomp1 \
        build-essential \
    && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------------
# Python dependencies
# ---------------------------------------------------------------------------
WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# ---------------------------------------------------------------------------
# Application files
# Preserve the workspace directory layout so that the Path(__file__)-relative
# lookups inside Api.py resolve correctly:
#   _MODEL_DIR   = __file__ / ../../.. / "Model Files"
#   _RAW_DATA_DIR = __file__ / ../../.. / "Raw Data"
# ---------------------------------------------------------------------------
COPY "Model Files/"  "./Model Files/"
COPY "Raw Data/patients.csv"  "./Raw Data/patients.csv"
COPY "Raw Data/visits.csv"    "./Raw Data/visits.csv"

COPY "Notebooks/Phase 5 — Deployment and API Integration/Api.py"     \
     "./Notebooks/Phase 5 — Deployment and API Integration/Api.py"
COPY "Notebooks/Phase 5 — Deployment and API Integration/index.html" \
     "./Notebooks/Phase 5 — Deployment and API Integration/index.html"

# validate.py is imported by Api.py at startup (sys.path insert to Phase 6 dir)
COPY "Notebooks/Phase 6 — Monitoring, Drift Detection, and Governance/validate.py" \
     "./Notebooks/Phase 6 — Monitoring, Drift Detection, and Governance/validate.py"

# Pre-create the logs directory (the logger also creates it at startup,
# but this ensures it exists even before the first request)
RUN mkdir -p "./Notebooks/Phase 5 — Deployment and API Integration/logs"

# ---------------------------------------------------------------------------
# Runtime
# ---------------------------------------------------------------------------
WORKDIR "/app/Notebooks/Phase 5 — Deployment and API Integration"

EXPOSE 8000

# Uvicorn without --reload for production; workers=1 keeps memory predictable.
# Scale horizontally with multiple containers rather than multiple workers
# (PyCaret models are large; multiple workers multiply RAM usage).
CMD ["uvicorn", "Api:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "1"]
