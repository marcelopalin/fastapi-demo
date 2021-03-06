# FastAPI demo :rocket:

Basic demo of some of the amazing functionalities of **FastAPI**. For more information visit https://fastapi.tiangolo.com/. 

## Requirements
Python 3.6+

## Running the demo

### Preparation

Create a virtual env:
```
python3 -m venv fastapi-env
source fastapi-env/bin/activate
pip install -r requirements.txt
```

Create the `previous` and `next` git aliases:
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




