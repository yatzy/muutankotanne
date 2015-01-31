
import sqlite3
from lxml import etree
import string

class DBCreator:
    
    def __init__(self, sqlfile):
        self.sqlfile = sqlfile

    def sqlConnection(funct):
        def connectionWrapper(*args,**kwargs):  
            try:
                conn = sqlite3.connect(args[0].sqlfile)
                c = conn.cursor()
                command,data = funct(*args, **kwargs)
                if len(data) > 0:
                    c.executemany(command,data)
                else:
                    c.execute(command)
                conn.commit()
                conn.close()
            except Exception,e:
                print e
        return connectionWrapper

    @sqlConnection
    def createTable(self, tablename, column_map):
        print column_map
        formats = []
        for key,item in column_map.items():
            formats.append('{0} {1}'.format(key, item))
        create_command = 'CREATE TABLE {0} ({1})'.format(tablename,string.join(formats,', '))
        print create_command
        print 'Generated table: {0}'.format(tablename)
        return create_command,{}

    @sqlConnection
    def insertXMLData(self, table, xmldata, columns):
        with open(xmldata,'r') as f:
            parsed_xml = etree.parse(f).getroot()

        insertformat = string.join(map(lambda x: "'{0}'=?".format(x), columns),', ')


        inserttypes = string.join(columns,',')
        insertqms = string.join(len(columns) * ['?'], ',')

        insertstr = 'INSERT INTO {0} ({1}) VALUES ({2})'.format(table,inserttypes, insertqms)
        
        insertdatas = []
        for element in parsed_xml.getchildren():

            data = dict()
            for child in element.getchildren():
                
                if isinstance(child, etree._Element):
                    datalist = []
                    for subchild in child.getchildren():
                        datalist.append(subchild.text)
                    data[child.tag] = string.join(datalist, ' ')
                elif child.text == None:
                    data[child.tag] = ''
                else:
                    data[child.tag] = child.text
            insertdatas.append(data)
            """
                insertdata = []
                for key in columns:
                    try:
                        insertdata.append(data[key])
                    except KeyError:
                        insertdata.append('')
                insertdatas.append(insertdata)
            """
        return insertstr, insertdatas

if __name__=='__main__':
    

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


    db = DBCreator('test.db')
    db.createTable('units', unit_map)
    db.insertXMLData('units', 'palvelukartta_palvelut.xml', unit_map.keys())
    
"""
    def createTable(self, datafile, sqlfile, keymap, typemap, picklist):
        # Creates a connection to the sql database
        conn = sqlite3.connect(sqlfile)
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


class PalvelukarttaDBCreator(DBCreator):

    def __init__(self):

        pass

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
"""
