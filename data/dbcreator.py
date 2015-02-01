import sqlite3
from lxml import etree
import string

class DBCreator:
    
    def __init__(self, sqlfile):
        """
        DBCreator creates SQLite databases.

        
        """
        self.sqlfile = sqlfile

    def sqlConnection(funct):
        def connectionWrapper(*args,**kwargs):
            try:
                conn = sqlite3.connect(args[0].sqlfile)
                c = conn.cursor()
                command,datas = funct(*args, **kwargs)
                if len(datas) > 0:
                    for data in datas:
                        c.execute(command,data)
                else:
                    c.execute(command)
                conn.commit()
                conn.close()
            except Exception,e:
                print e
        return connectionWrapper

    @sqlConnection
    def createTable(self, tablename, columns, columntypes):
        formats = []
        for key,item in zip(columns,columntypes):
            formats.append('{0} {1}'.format(key, item))
        create_command = 'CREATE TABLE {0} ({1})'.format(tablename,string.join(formats,', '))
        print 'Generated table: {0}'.format(tablename)
        return create_command,[]

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
                
                if len(child.getchildren()) > 0:
                    datalist = []
                    for subchild in child.getchildren():
                        datalist.append(subchild.text)
                    data[child.tag] = string.join(datalist, ' ')
                elif child.text == None:
                    data[child.tag] = ''
                else:
                    data[child.tag] = child.text
            insertdata = []
            for key in columns:
                try:
                    insertdata.append(data[key])
                except KeyError:
                    insertdata.append('')
            insertdatas.append(insertdata)
        
        return insertstr, insertdatas

if __name__=='__main__':
    
    # Helsinki Palvelukartta REST-API
    # http://www.hel.fi/palvelukarttaws/rest/ver2.html

    unit_map    =   {
                    'id':'PRIMARY KEY',
                    'org__id':'INT',
                    'provider__type':'INT',
                    'service__ids':'TEXT',
                    'name__fi':'TEXT',
                    'name__sv':'TEXT',
                    'name__en':'TEXT',
                    'latitude':'REAL',
                    'longitude':'REAL',
                    'northing__etrs__gk25':'INT',
                    'easting__etrs__gk25':'INT',
                    'easting__etrs__gk25':'INT'
                    }
    service_map =   {
                    'id':'PRIMARY KEY',
                    'name__fi':'TEXT',
                    'name__sv':'TEXT',
                    'name__en':'TEXT',
                    'unit__ids':'TEXT'
                    }


    db = DBCreator('muutankotanne.db')
    columns, types = zip(*unit_map.items())
    db.createTable('units', columns, types)
    db.insertXMLData('units', 'palvelukartta_toimipisteet.xml', columns)
    columns, types = zip(*service_map.items())
    db.createTable('services', columns, types)
    db.insertXMLData('services', 'palvelukartta_palvelut.xml', columns)
