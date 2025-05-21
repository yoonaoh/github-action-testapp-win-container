from flask import Flask
import platform
import socket

app = Flask(__name__)

@app.route('/')
def hello():
    hostname = socket.gethostname()
    return f"""
    <h1>Hello from Windows Container!</h1>
    <p>Container Hostname: {hostname}</p>
    <p>Python Version: {platform.python_version()}</p>
    <p>OS: {platform.platform()}</p>
    """

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
