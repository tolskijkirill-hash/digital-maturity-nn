FROM python:3.12-slim
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8080 \
    DATABASE_PATH=/data/app.db
WORKDIR /app
COPY digital_maturity_mvp_railway.zip /tmp/source.zip
RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/* \
    && unzip -q /tmp/source.zip -d /tmp/source \
    && cp -a /tmp/source/digital_maturity_mvp/. /app/ \
    && python -c "import re; from pathlib import Path; p=Path('/app/app/main.py'); s=p.read_text(); s=re.sub(r\"templates\\.TemplateResponse\\('([^']+)',\\{'request':request,\", r\"templates.TemplateResponse(request, '\\1', {\", s); p.write_text(s)" \
    && rm -rf /tmp/source /tmp/source.zip \
    && pip install --no-cache-dir -r requirements.txt \
    && mkdir -p /data
EXPOSE 8080
CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8080}"]
