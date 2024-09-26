import os
from dotenv import load_dotenv
load_dotenv()

class Config:
     
    @classmethod
    @property
    def telegram_token(cls)-> str:
        return os.getenv('TELEGRAM_API_TOKEN')
    
    @classmethod
    @property
    def dsn(cls)-> str:
        return os.getenv('DATABASE_DSN')
    
    @classmethod
    @property
    def host_service(cls)-> str:
        return os.getenv('HOST_SERVICE')
    
    @classmethod
    @property
    def host_app(cls)-> str:
        return os.getenv('HOST_APP')
    
    @staticmethod
    def port_service(service: str)-> str:
        return int(os.getenv(f'{service}_PORT'))