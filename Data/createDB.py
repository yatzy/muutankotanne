import sqlite3
from lxml import etree
import string

unit_map    =   {
                'id':'PRIMARY KEY',
                'org__id':'INT',
                'provider__type':'INT',
                'service__ids':'TEXT',
                'sources':'TEXT',
                'name__fi':'TEXT',
                'name__sw':'TEXT',
                'name__en':'TEXT',
                'latitude':'REAL',
                'longitude':'REAL',
                'northing__etrs__gk25':'INT',
                'easting__etrs__gk25':'INT',
                'easting__etrs__gk25':'INT'
                }

conn = sqlite3.connect('database.db')
c = conn.cursor()
try:
    units_formats = []

    for key,item in unit_map.items():
        units_formats.append('{0} {1}'.format(key, item))


    unittable_create = 'CREATE TABLE units ({0})'.format(string.join(units_formats,', '))


    c.execute(unittable_create)
    print 'Generated main table.'
except sqlite3.OperationalError as e:
    print 'Main table already exists.'

with open('PKS_Units.xml','r') as f:
    parsed_xml = etree.parse(f).getroot()

insertkeys  = unit_map.keys()

insertformat = string.join(map(lambda x: "'{0}'=?".format(x), insertkeys),', ')


inserttypes = string.join(insertkeys,',')
insertqms = string.join(len(insertkeys) * ['?'], ',')

insertstr = 'INSERT INTO units ({0})  VALUES ({1})'.format(inserttypes, insertqms)

for element in parsed_xml.getchildren():

    data = dict()
    for child in element.getchildren():
        if child.text == None:
            data[child.tag] = ''
        else:
            data[child.tag] = child.text
    insertdata = []
    for key in insertkeys:
        try:
            insertdata.append(data[key])
        except KeyError:
            insertdata.append('')
    try:
        c.execute(insertstr,insertdata)
    except sqlite3.OperationalError as e:
        print 'Entry already exists.'

    print u'Generating entry for: {0}'.format(data['name__fi'])

conn.commit()
conn.close()
