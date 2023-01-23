from flask import jsonify, request, Flask
import psycopg2

app = Flask(__name__)

conn = psycopg2.connect(
    database="worldcup2022",
    user="example",
    password="example",
    host="db",
    port="5432"
)


def init_db():
    cursor = conn.cursor()
    cursor.execute('DROP TABLE IF EXISTS matches;')
    postgreSQL_create_table = 'CREATE TABLE if not exists matches (id  SERIAL PRIMARY KEY, homeTeam VARCHAR(50) NULL DEFAULT NULL, homeTeamScore integer NULL DEFAULT NULL,awayTeam VARCHAR(50) NULL DEFAULT NULL,awayTeamScore integer NULL DEFAULT NULL,Date DATE NULL DEFAULT NULL);'
    cursor.execute(postgreSQL_create_table)
    cursor = conn.cursor()
    postgreSQL_insert = "INSERT INTO matches (homeTeam, awayTeam, homeTeamScore, awayTeamScore, Date) VALUES('England', 'Iran', 6, 2, '2022-11-21'), ('Senegal', 'Netherlands', 0, 2, '2022-11-21'), ('USA', 'Wales', 1, 1, '2022-11-21'),('Argentina', 'Suadi Arabia', 1, 2, '2022-11-22'),('Denmark', 'Tunisia', 0, 0, '2022-11-22'),('Mexico', 'Poland', 0, 0, '2022-11-22'),('France', 'Australia', 4, 1, '2022-11-22'),('Morocco', 'Croatia', 0, 0, '2022-11-23'),('Germany', 'Japan', 1, 2, '2022-11-23'),('Spain', 'Costa Rica', 7, 0, '2022-11-23'),('Belgium', 'Canada', 1, 0, '2022-11-23'),('Switzerland', 'Cameroon', 1, 0, '2022-11-24'),('Uruguay', 'South Korea', 0, 0, '2022-11-24'),('Portugal', 'Ghana', 3, 2, '2022-11-24'),('Brazil', 'Serbia', 2, 0, '2022-11-24'),('Wales', 'Iran', 0, 2, '2022-11-25'),('Qatar', 'Senegal', 1, 2, '2022-11-25'),('Netherlands', 'Ecuador', 1, 1, '2022-11-25'),('England', 'USA', 0, 0, '2022-11-25'),('Tunisia', 'Australia', 0, 1, '2022-11-26'),('Poland', 'Saudi Arabia', 0, 2, '2022-11-26'),('France', 'Denmark', 2, 1, '2022-11-26'),('Argentina', 'Mexico', 2, 0, '2022-11-26'),('Japan', 'Costa Rica', 0, 1, '2022-11-27'),('Belgium', 'Morocco', 0, 2, '2022-11-27'),('Croatia', 'Canada', 4, 1, '2022-11-27'),('Spain', 'Germany', 1, 1, '2022-11-27');"
    cursor.execute(postgreSQL_insert)
    conn.commit()


@app.route("/", methods=["GET"])
def hello():
    init_db()
    return 'Hi'


@app.route("/getAllMatches", methods=["GET"])
def get_all_matches():
    cursor = conn.cursor()
    cursor.execute(
        'SELECT id, homeTeam, awayTeam, homeTeamScore, awayTeamScore, date FROM "matches"')
    rows = cursor.fetchall()
    return jsonify([{"id": row[0], "homeTeam": row[1], "awayTeam": row[2], "homeTeamScore": row[3], "awayTeamScore": row[4], "date": row[5]} for row in rows])


@app.route("/getMatchesByTeam/<team>", methods=['GET', 'POST'])
def get_matches_by_team(team):
    cursor = conn.cursor()
    cursor.execute(
        'SELECT id, homeTeam, awayTeam, homeTeamScore, awayTeamScore, date FROM "matches" WHERE homeTeam = %s OR awayTeam = %s', (team, team))
    rows = cursor.fetchall()
    return jsonify([{"id": row[0], "homeTeam": row[1], "awayTeam": row[2], "homeTeamScore": row[3], "awayTeamScore": row[4], "date": row[5]} for row in rows])


@app.route("/deleteMatch/<string:match_id>", methods=['GET', 'POST'])
def delete_match(match_id):
    cursor = conn.cursor()
    cursor.execute('DELETE FROM "matches" WHERE id = %s', (match_id,))
    conn.commit()
    return "Deleted"


@app.route("/addMatch", methods=['GET', 'POST'])
def add_match():
    data = request.get_json()
    homeTeam = data.get("homeTeam")
    awayTeam = data.get("awayTeam")
    homeTeamScore = data.get("homeTeamScore")
    awayTeamScore = data.get("awayTeamScore")
    date = data.get("date")
    cursor = conn.cursor()
    cursor.execute('INSERT INTO "matches" (homeTeam, awayTeam, homeTeamScore, awayTeamScore, date) VALUES (%s, %s, %s, %s, %s)',
                   (homeTeam, awayTeam, homeTeamScore, awayTeamScore, date))
    conn.commit()
    return "Match has been added successfully."


if __name__ == '__main__':
    init_db()
    app.run(host="0.0.0.0", debug=True)
