# — MySQL —
MYSQL_HOST     = "localhost"
MYSQL_USER     = "root"        # sostituisci con il tuo user
MYSQL_PASSWORD = "password"    # sostituisci con la tua password
MYSQL_DB       = "seven_app"   # controlla che il db esista

# — MongoDB Atlas —
MONGO_USERNAME = "root"        # sostituisci con il tuo user
MONGO_PASSWORD = "password"    # sostituisci con la tua password
MONGO_URI      = (
    f"mongodb+srv://{MONGO_USERNAME}:{MONGO_PASSWORD}"
    "@sevenapp.zbyc3hu.mongodb.net/seven_app_mongo"
    "?retryWrites=true&w=majority"
)
MONGO_DB   = "seven_app_mongo" # controlla che il db esista
MONGO_COLL = "posts"