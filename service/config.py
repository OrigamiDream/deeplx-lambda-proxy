from pydantic_settings import BaseSettings


class Settings(BaseSettings):

    function_index: int

    class Config:
        env_file = '.env'
