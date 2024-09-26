import os
import logging

# Directory for storing log files
__DIR__ = "logs"
if not os.path.exists(__DIR__):
    os.makedirs(__DIR__)

# Format for log messages
__FORMAT__ = "%(asctime)s - %(levelname)s - %(name)s.%(funcName)s : %(message)s"

# Custom formatter class for console and file output
class CustomFormatter(logging.Formatter):

    # ANSI color codes for different log levels
    grey = "\x1b[32m"       # DEBUG
    blue = "\x1b[34m"       # INFO
    yellow = "\x1b[33;20m"  # WARNING
    red = "\x1b[31;20m"     # ERROR
    bold_red = "\x1b[31;1m" # CRITICAL
    reset = "\x1b[0m"       # Reset color

    # Formats dictionary for different log levels
    FORMATS = {
        logging.DEBUG: grey + __FORMAT__ + reset,
        logging.INFO: blue + __FORMAT__ + reset,
        logging.WARNING: yellow + __FORMAT__ + reset,
        logging.ERROR: red + __FORMAT__ + reset,
        logging.CRITICAL: bold_red + __FORMAT__ + reset
    }

    def format(self, record) -> str:
        """Override format method to apply custom formatting."""
        log_fmt = self.FORMATS.get(record.levelno)
        formatter = logging.Formatter(log_fmt)
        return formatter.format(record)

class Logger:
    
    @staticmethod
    def create(name: str, file: bool = False) -> logging.Logger:
        """Returns a configured logger instance."""

        # Create logger with specified name
        logger = logging.getLogger(name)
        logger.setLevel(logging.DEBUG)  # Set logger level to DEBUG

        # Console handler for logging to console
        console_handler = logging.StreamHandler()
        console_handler.setLevel(logging.DEBUG)
        console_handler.setFormatter(CustomFormatter())
        logger.addHandler(console_handler)

        # Optional file handler for logging to a file
        if file:
            log_file = os.path.join(__DIR__, name.replace(" ", "")+".log")
            file_handler = logging.FileHandler(log_file)
            file_handler.setLevel(logging.DEBUG)
            file_handler.setFormatter(
                logging.Formatter(
                    fmt=__FORMAT__,
                )
            )
            logger.addHandler(file_handler)

        return logger

    @staticmethod
    def get(name: str)-> logging.Logger:
        """Returns a configured logger instance."""
        return logging.getLogger(name)
