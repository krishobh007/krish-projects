import sys
import argparse
import MySQLdb as mdb

DELIM = '####$$##%'

airtel_query = 'SELECT c.message, cv.category_id \
                FROM artl_comments_verified as cv, artl_comments as c \
                WHERE c.comment_id=cv.comment_id'

rose_query = 'SELECT a.message, b.sentimental_key_value \
              FROM rstsmedia_facebook_comments as a, rstsmedia_facebook_comments_verified as b \
              WHERE a.comment_id=b.comment_id'

def airtel_category_name(category_id):
    # copied from aitel_fb_categories table
    data = { 'POSITIVE' : [1],
             'NEGATIVE' : [2,3,4,5,6,8],
             'NEUTRAL'  : [7],
            }
    for cat, ids in data.items():
        if int(category_id) in ids:
            return cat
    return 'UNKNOWN'

def rose_category_name(category_id):
    # copied from aitel_fb_categories table
    data = { 'POSITIVE' : ['P'],
             'NEGATIVE' : ['N'],
             'NEUTRAL'  : ['NU'],
            }
    for cat, ids in data.items():
        if category_id in ids:
            return cat
    return 'UNKNOWN'

def main(host, user, passwd, db, query, name):
    conn = mdb.connect(host, user, passwd, db)
    cur = conn.cursor()
    cur.execute(query)
    results = cur.fetchall()
    for row in results:
        cat = name(row[1])
        if cat != 'UNKNOWN':
            print row[0].replace("\n", ' ') + DELIM + cat
    conn.close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Parse verified comments \
                                                  from DB and print in stdout')
    parser.add_argument('--dbhost', nargs=1, required=True, dest='host',
                        help='Datbase server which holds the required dbs')
    parser.add_argument('--dbuser', nargs=1, required=True, dest='user',
                        help='Datbase username')
    parser.add_argument('--dbpass', nargs=1, required=True, dest='passwd',
                        help='Datbase password')
    parser.add_argument('--dbname', nargs=1, required=True, dest='database',
                        help='Datbase name which holds the required tables')
    parser.add_argument('--src', nargs=1, required=True, dest='src',
                        help='Dataset to parse', choices=['airtel_fb_comments', 'rose_comments'])
    args = parser.parse_args()
    src = args.src[0]
    if src == 'airtel_fb_comments':
        query = airtel_query
        name = airtel_category_name
    elif src == 'rose_comments':
        query = rose_query
        name = rose_category_name
    main(args.host[0], args.user[0], args.passwd[0], args.database[0], query, name)
