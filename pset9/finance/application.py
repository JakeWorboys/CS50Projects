import os

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from tempfile import mkdtemp
from werkzeug.exceptions import default_exceptions, HTTPException, InternalServerError
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import apology, login_required, lookup, usd

# Configure application
app = Flask(__name__)

# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True


# Ensure responses aren't cached
@app.after_request
def after_request(response):
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


# Custom filter
app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_FILE_DIR"] = mkdtemp()
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///finance.db")

# Make sure API key is set
if not os.environ.get("API_KEY"):
    raise RuntimeError("API_KEY not set")


# Setup for index/home page.
@app.route("/")
@login_required
def index():
    """Show portfolio of stocks"""

    # Check if user owns stocks in the database and display them if so.
    rnge = len(db.execute("SELECT stock FROM stocks WHERE id = ?", session["user_id"]))

    if rnge > 0:
        portfolio = {
        }
        count = 0
        for i in range(rnge):
            stock = db.execute("SELECT DISTINCT(stock) FROM stocks WHERE id = ?", session["user_id"])[i]
            sharesowned = db.execute("SELECT amount FROM stocks WHERE stock = ?", stock["stock"])
            wallet = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])[0]["cash"]
            shares = sharesowned[0]["amount"]
            stockframe = lookup(stock["stock"])
            currentprice = stockframe["price"]
            holdvalue = shares * currentprice
            bal = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])
            balance = bal[0]["cash"]
            total = balance + holdvalue
            count += 1

            portfolio[i] = [stock["stock"], shares, usd(currentprice), usd(holdvalue), usd(total),]

        return render_template("index.html", portfolio=portfolio, count=count, wallet=usd(wallet))
    else:
        # Shows a message stating that the user does not own any stocks currently.
        return render_template("newuser.html")


# Setup for stock buying system.
@app.route("/buy", methods=["GET", "POST"])
@login_required
def buy():
    """Buy shares of stock"""
    if request.method == "POST":
        # Retrieves form data and assigns variables.
        symbol = request.form.get("symbol")
        if not symbol:
            return apology("Symbol does not exist")
        shares = request.form.get("shares")
        if not shares:
            return apology("Not a positive number")
        trans = "Buy"

        stock = lookup(symbol)
        if not stock:
            return apology("Symbol not recognized")

        # Ensures shares input is a usable number in system.
        if shares.isnumeric() == 0:
            return apology("Must enter a valid number")

        buy = float(stock["price"]) * int(shares)
        power = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])
        power = float(power[0]["cash"])

        # Checks if user has large enough wallet to accomodate buy.
        if buy < power:
            owned = len(db.execute("SELECT stock FROM stocks WHERE id = ? AND stock = ?", session["user_id"], symbol))
            # Checks if user currently owns an amount of the stock they are looking to purchase.
            if owned > 0:
                db.execute("UPDATE stocks SET amount = amount + ? WHERE id = ? AND stock = ?", int(shares), session["user_id"], symbol)
                db.execute("UPDATE users SET cash = ? WHERE id = ?", power - buy, session["user_id"])
                db.execute("INSERT INTO history (id, stock, amount, value, type) VALUES (?, ?, ?, ?, ?)", session["user_id"], symbol, int(shares), usd(buy), trans)
            else:
                db.execute("INSERT INTO stocks (id, stock, amount, buyprice) VALUES (?, ?, ?, ?)", session["user_id"], stock["symbol"], shares, stock["price"])
                db.execute("UPDATE users SET cash = ? WHERE id = ?", power - buy, session["user_id"])
                db.execute("INSERT INTO history (id, stock, amount, value, type) VALUES (?, ?, ?, ?, ?)", session["user_id"], symbol, int(shares), usd(buy), trans)
        else:
            return apology("Not enough funds")

        return redirect("/")
    else:
        return render_template("buy.html")


# Allows user to view transaction history, last 5 transactions.
@app.route("/history")
@login_required
def history():
    """Show history of transactions"""
    hist = len(db.execute("SELECT * FROM history WHERE id = ? LIMIT 5", session["user_id"]))
    if hist > 5:
        hist = 5
    history = {
    }
    history = db.execute("SELECT * FROM history WHERE id = ? ORDER BY nmbr DESC LIMIT ?", session["user_id"], hist)

    return render_template("history.html", hist=hist, history=history)


@app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in"""

    # Forget any user_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("Must provide username")

        # Ensure password was submitted
        elif not request.form.get("password"):
            return apology("Must provide password")

        # Query database for username
        rows = db.execute("SELECT * FROM users WHERE username = ?", request.form.get("username"))

        # Ensure username exists and password is correct
        if len(rows) != 1 or not check_password_hash(rows[0]["hash"], request.form.get("password")):
            return apology("Invalid username and/or password")

        # Remember which user has logged in
        session["user_id"] = rows[0]["id"]

        # Redirect user to home page
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("login.html")


@app.route("/logout")
def logout():
    """Log user out"""

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    return redirect("/")


# Allows user to lookup current value of a stock.
@app.route("/quote", methods=["GET", "POST"])
@login_required
def quote():
    """Get stock quote."""
    if request.method == "POST":
        symbol = request.form.get("symbol")
        if not symbol:
            return apology("Please input a symbol", 400)

        # Use dedicated lookup function to create dictionary entry.
        qte = lookup(symbol)
        if not qte:
            return apology("Symbol not found")

        return render_template("quoted.html", qte=qte)
    elif request.method == "GET":
        return render_template("quote.html")


# Allows new users to register in the db.
@app.route("/register", methods=["GET", "POST"])
def register():
    """Register user"""
    if request.method == "POST":
        username = request.form.get("username")
        if not username:
            return apology("Please input a username")
        password = request.form.get("password")
        if not password:
            return apology("Please input a password")
        confirm = request.form.get("confirmation")
        if not confirm:
            return apology("Please confirm your password")
        if password != confirm:
            return apology("Passwords did not match")

        # Uses sqlite query to establish whether requested username already exists.
        inuse = len(db.execute("SELECT username FROM users WHERE ? IN (SELECT username FROM users)", username))
        if inuse > 0:
            return apology("Username already in use")

        # Hashes password and inserts user into db.
        phash = generate_password_hash(password, method='pbkdf2:sha256', salt_length=8)
        db.execute("INSERT INTO users (username, hash) VALUES(?, ?)", username, phash)
        return redirect("/login")

    return render_template("register.html")


# Setup for the stock selling system.
@app.route("/sell", methods=["GET", "POST"])
@login_required
def sell():
    """Sell shares of stock"""
    # Creates length variable for loop in html.
    rnge = len(db.execute("SELECT stock FROM stocks WHERE id = ?", session["user_id"]))

    # Creates table and forms for sales service if user currently owns any shares.
    if rnge > 0:
        portfolio = {
        }
        count = 0
        for i in range(rnge):
            stock = db.execute("SELECT DISTINCT(stock) FROM stocks WHERE id = ?", session["user_id"])[i]
            sharesowned = db.execute("SELECT amount FROM stocks WHERE stock = ?", stock["stock"])
            wallet = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])[0]["cash"]
            shares = sharesowned[0]["amount"]
            stockframe = lookup(stock["stock"])
            currentprice = stockframe["price"]
            holdvalue = shares * currentprice
            bal = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])
            balance = bal[0]["cash"]
            total = balance + holdvalue
            count += 1

            portfolio[i] = [stock["stock"], shares, usd(currentprice), usd(holdvalue), usd(total)]

        options = {
        }
        options = db.execute("SELECT DISTINCT(stock) FROM stocks WHERE id = ?", session["user_id"])
        optnum = len(options)

        if request.method == "POST":
            symbol = request.form.get("symbol")
            if not symbol:
                return apology("Symbol not recognized")
            sell = request.form.get("shares")
            if not sell:
                return apology("Please input valid number of shares")
            if sell.isnumeric() == 0:
                return apology("Please input valid number of shares")
            trans = "Sell"

            stockowned = len(db.execute("SELECT stock FROM stocks WHERE id = ? AND stock = ?", session["user_id"], symbol))
            amountowned = db.execute("SELECT amount FROM stocks WHERE id = ? AND stock = ?", session["user_id"], symbol)[0]["amount"]
            cp = lookup(symbol)
            cp = cp["price"]
            sale = float(cp) * float(sell)

            if stockowned > 0:
                if int(sell) < amountowned:
                    db.execute("UPDATE users SET cash = cash + ? WHERE id = ?", sale, session["user_id"])
                    db.execute("UPDATE stocks SET amount = amount - ? WHERE id = ?", sell, session["user_id"])
                    db.execute("INSERT INTO history (id, stock, amount, value, type) VALUES (?, ?, ?, ?, ?)", session["user_id"], symbol, sell, usd(sale), trans)
                elif int(sell) == amountowned:
                    db.execute("UPDATE users SET cash = cash + ? WHERE id = ?", sale, session["user_id"])
                    db.execute("DELETE FROM stocks WHERE stock = ? AND id = ?", symbol, session["user_id"])
                    db.execute("INSERT INTO history (id, stock, amount, value, type) VALUES (?, ?, ?, ?, ?)", session["user_id"], symbol, sell, usd(sale), trans)
                else:
                    return apology("Not enough owned shares")
            else:
                return apology("Stock not owned")

            return redirect("/sell")
    else:
        return render_template("sell2.html")

    return render_template("sell.html", portfolio=portfolio, count=count, wallet=usd(wallet), options=options, optnum=optnum)


def errorhandler(e):
    """Handle error"""
    if not isinstance(e, HTTPException):
        e = InternalServerError()
    return apology(e.name, e.code)


# Listen for errors
for code in default_exceptions:
    app.errorhandler(code)(errorhandler)
