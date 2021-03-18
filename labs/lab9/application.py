import os

from cs50 import SQL
from flask import Flask, flash, jsonify, redirect, render_template, request, session

# Configure application
app = Flask(__name__)

# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///birthdays.db")

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        name = request.form.get("name")
        if not name:
            return redirect("/")
        month = request.form.get("month")
        if not month:
            return redirect("/")
        day = request.form.get("day")
        if not day:
            return redirect("/")

        db.execute("INSERT INTO birthdays (name, month, day) VALUES(?, ?, ?)", name, month, day)

        return redirect("/")

    else:

        # TODO: Display the entries in the database on index.html
        birthdays = db.execute("SELECT * FROM birthdays")
        return render_template("index.html", birthdays = birthdays)

@app.route("/deregister", methods=["POST"])
def deregister():
    if request.method == "POST":
        did = request.form.get("id")
        if not did:
            return redirect("/")

        db.execute("DELETE FROM birthdays WHERE id IN (?)", did)

        return redirect("/")
