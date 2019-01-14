import sys
sys.stdout = sys.stderr
sys.path.insert(0, '/var/www/app/')
from app import app as application
