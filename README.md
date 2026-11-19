# Lab 07 — CI/CD avec Jenkins et Docker

Application Flask minimaliste pilotée par un pipeline Jenkins en 5 étapes :
**Checkout → Build → Test → Deploy → Verify**.

## Structure

```
jenkins-flask-lab/
├── app.py                 # routes / et /health
├── requirements.txt       # Flask, pytest, gunicorn
├── Dockerfile             # image Python 3.12 + gunicorn
├── Jenkinsfile            # pipeline Jenkins (Pipeline script from SCM)
├── tests/test_app.py      # 2 tests pytest
└── README.md
```

Dépôt GitHub : https://github.com/Amar788kar/jenkins-flask-lab

## Vérification locale (sans Jenkins)

```bash
# Tests dans un conteneur éphémère (identique à l'étape Test)
docker build -t jenkins-flask-lab:local .
docker run --rm jenkins-flask-lab:local pytest -v

# Application (identique à l'étape Deploy)
docker rm -f jenkins-flask-app || true
docker run -d --name jenkins-flask-app -p 8081:8000 -e APP_VERSION=local jenkins-flask-lab:local

curl http://localhost:8081/health   # {"status":"ok"}
curl http://localhost:8081/         # <h1>Jenkins CI/CD Lab</h1> ... Version: local
```

## Configuration du job Jenkins

1. `http://localhost:8080` → **New Item** → nom `jenkins-flask-lab` → **Pipeline** → OK.
2. Pipeline → Definition : **Pipeline script from SCM**.
3. SCM : **Git**, URL : `https://github.com/Amar788kar/jenkins-flask-lab.git`
4. Branches to build : `*/main` ; Script Path : `Jenkinsfile`.
5. Save → **Build Now** → **Console Output**.

Le compte de service Jenkins doit pouvoir accéder au daemon Docker (ne pas faire cela sur un
serveur partagé ou de production). Le dépôt étant public, aucun identifiant GitHub n'est requis.

> Note : le texte du sujet issu du PDF avait des coupures dans les commandes du Jenkinsfile
> (`IMAGE` + `NAME:`, `-p APP PORT: 8000 − eAPP VERSION = ...`). Elles ont été reconstituées en
> syntaxe Groovy valide : `${IMAGE_NAME}:${BUILD_NUMBER}` et `-p ${APP_PORT}:8000 -e APP_VERSION=${BUILD_NUMBER}`.

Le rapport et les réponses aux questions des sections 19 et 20 sont dans [RAPPORT.md](RAPPORT.md).
