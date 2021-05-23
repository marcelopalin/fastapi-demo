# Documentação em Pt-br
# FastAPI demo :rocket:

Este projeto originou-se com a Camila Andrea González Williamson que explica
passo a passo neste vídeo [video!](https://www.youtube.com/watch?v=nHGAGtxSeNk). 
Com excelente didática. Vou tentar manter o mesmo padrão e acrescentar outras
funcionalidades como Autenticação, Banco de Dados, Frontend, Dockerfile...

# Resumo

Foi construído até o momento uma API (com FastAPI) para cadastro e análise das
palavras de um artigo com o pacote spacy (caso não conheça acesse: https://spacy.io/usage/spacy-101)

> spaCy é uma biblioteca de código aberto gratuita para Processamento de Linguagem Natural (PNL) avançado em Python.

O projeto tem 2 tags:

```
$ git tag
demo-end
demo-start
```


## Requisitos para Rodar com Docker

Docker instalado:

Execute:

```
docker-compose up -d
```

Acesse: http://localhost:5000/docs


# Release 1.0.0

Neste momento vou criar a Tag 1.0.0 considerando que as alterações
que farei estão a partir deste ponto.

```
git tag -a 1.0.0 -m "FastAPI Coll Api Inicial finalizada"
```


## Requisitos para Rodar o Projeto Manualmente


```
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python -m spacy download en_core_web_sm
```

Crie os atalhos no Git `git previous` e `git next`

```
git config --global alias.previous '!git checkout $(git rev-list demo-start~1..HEAD | head -2 | tail -1)'
git config --global alias.next '!git checkout $(git rev-list HEAD..demo-end | tail -1 )'
```
Foi utilizado no vídeo: [video!](https://www.youtube.com/watch?v=nHGAGtxSeNk)


Para acompanhar o projeto desde o início seguindo o vídeo utilize a Tag: **demo-start**

```
git checkout demo-start
```

### Let the demo start :sparkles:
Rodando o app. Obs: não se esqueça de ativar seu ambiente virtual antes:

```
source .venv/bin/activate (no linux)
```

```
uvicorn main:app --reload
```

Agora você pode acompanhar o avanço do código com `git next` e  `git previous`
em outro terminal. O primeiro terminal deixe rodando o **uvicorn** e em outro
vá digitando git next ou git previous. Basta dar um refreshe no Browser (F5)
que já conseguirá ver as alterações entre os commits.


A demonstração termina no commit 41be930448ddb24e88e4602eb615389951c50f1b: `Add 404 response to docs`. 

Depois disso use `git checkout master`. Não se esqueça de matar o servidor e rodar novamente:

```
uvicorn app.main:app --reload
```


# Documentação Original - En
# FastAPI demo :rocket:

Step-by-step demo of some of the amazing functionalities of **FastAPI**. Check out the [video!](https://www.youtube.com/watch?v=nHGAGtxSeNk)

## Requirements
Python 3.6+

## Running the demo

### Preparation

Create a virtual env:
```
python3 -m venv fastapi-env
source fastapi-env/bin/activate
pip install -r requirements.txt
python -m spacy download en_core_web_sm
```

Create the `git previous` and `git next` aliases:
```
git config --global alias.previous '!git checkout $(git rev-list demo-start~1..HEAD | head -2 | tail -1)'
git config --global alias.next '!git checkout $(git rev-list HEAD..demo-end | tail -1 )'
```

Checkout the demo-start tag:
```
git checkout demo-start
```

### Let the demo start :sparkles:
Run the app:
```
uvicorn main:app --reload
```

When you are ready, move to the next step with `git next`.
To move backwards use  `git previous`.

The demo ends at commit 41be930448ddb24e88e4602eb615389951c50f1b: `Add 404 response to docs`. 
After this, use `git checkout master` to see how the app can be evolved
by using some other features of FastAPI. From this point run the app as:
```
uvicorn app.main:app --reload
```


# Other Projects Interesting

https://github.com/Kludex/awesome-fastapi-projects

https://github.com/OSS-team-zulu/Zulu


