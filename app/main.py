from fastapi import FastAPI

from dynaconf import Dynaconf
settings = Dynaconf(
    envvar_prefix="COOLAPI",
    settings_files=["settings.toml", ".secrets.toml"],
    environments=True,
    load_dotenv=True,
)
from fastapi.middleware.cors import CORSMiddleware
from .routers import analytics, articles, greetings

app = FastAPI(
    title=settings.TITLE_API,
    debug=settings.DEBUG,
    description=settings.DESCRIPTION_API,
    version=settings.VERSION_API,
)

origins = [
    "http://localhost:3000",
    "http://127.0.0.1:3000",
    "http://localhost:8342",
    "http://127.0.0.1:8342",
    f"http://{settings.API_HOST}:{settings.API_PORT}",
    f"https://{settings.API_HOST}:{settings.API_PORT}",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


app.include_router(greetings.router)
app.include_router(articles.router)
app.include_router(analytics.router)

@app.on_event('startup')
def startup_event():
    print(f"{settings.MSG_ENVIRONMENT}")

