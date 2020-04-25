from flask import current_app
def main():

    current_app.logger.info("This is log message")

    return "My First Example"
