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

units_formats = []

for key,item in unit_map.items():
    units_formats.append('{0} {1}'.format(key, item))


unittable_create = 'CREATE TABLE units ({0})'.format(string.join(units_formats,', '))

print unittable_create

c.execute(unittable_create)

with open('PKS_Units.xml','r') as f:
    parsed_xml = etree.parse(f).getroot()

print parsed_xml.getchildren()[0].getchildren()

conn.commit()
conn.close()
