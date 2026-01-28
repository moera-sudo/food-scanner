# Note

The project was created in a hurry, basically “for the checkbox” in college, so the code quality and overall project structure leave a lot to be desired :P  

I’m not making excuses — just giving context.

---

# About the Project

I’m not going to write full documentation for this project, because there’s nothing particularly special here and the project itself is small.  
All available endpoints can be viewed directly in the FastAPI Swagger UI. Below is a short overview of the tech stack and instructions on how to run the project.

## Backend setup

1) After cloning the repository, create a `.env` file in the root directory with approximately the following variables:

```

# FastAPI settings

APP_NAME = foo-api
APP_VERSION = 0.1.0
APP_DESC = api
DEBUG = True

# Database connection settings

DB_USERNAME = postgres
DB_NAME = FooDatabase
DB_PASSWORD = 123
DB_HOST = localhost
DB_PORT = 5432
DB_DRIVER = asyncpg

# Auth settings

SECRET_KEY = secretname
REFRESH_SECRET_KEY = refreshsecretname
ALGORITHM = HS256
ACCESS_TOKEN_EXPIRE = 60
REFRESH_TOKEN_EXPIRE = 1

```

2) Install Poetry and run `poetry install` inside the `foo_backend` directory.

3) I recommend starting the server with the following command (also from the `foo_backend` directory):

```

poetry run uvicorn src.main:app --reload

```

## Frontend (Flutter)

4) Flutter setup is even simpler. The project does not use any additional services like Firebase. Just run:

```

flutter pub get
flutter run

```

The project is intended for mobile devices.

5) If you need to run the client on an OS other than Android, you’ll need to run:

```

flutter create .

```

This is required because I removed all platform-specific folders to avoid cluttering the project.


