import psycopg2
from psycopg2.extras import DictCursor


credentials = {
    'host' : 'localhost',
    'user' : 'shop',
    'dbname' : 'shop',
    'password' : 'shop'
}


connection = None
def get_connection():
    global connection
    if not connection:
        connection = psycopg2.connect(**credentials)
        connection.autocommit = True
    return connection


class DbException(Exception):
    pass


class Item:
    conn = get_connection()
    
    def __init__(self, _newid=None):
        self._id = None
        self._category_id = None
        self._title = None
        self._price = None
        self._ismodified = False
        
        if _newid:
            self.__load(_newid)
        
    @property
    def id(self):
        return self._id
        
    @property
    def category_id(self):
        return self._category_id
        
    @property
    def title(self):
        return self._title
        
    @property
    def price(self):
        return self._price
        
    @title.setter
    def title(self, title):
        self._ismodified = True
        self._title = title
    
    @category_id.setter
    def category_id(self, category_id):
        self._ismodified = True
        self._category_id = category_id
        
    @price.setter
    def price(self, price):
        self._ismodified = True
        self._price = price
        
    def __load(self, _newid):
        cursor = self.conn.cursor(cursor_factory=DictCursor)
        cursor.execute(
            f'SELECT * FROM "item" WHERE id = {_newid}'
        )
        item = cursor.fetchone()
        cursor.close()
        
        if not item:
            raise DbException(f'There is no such ID in TABLE as({_newid})')
            
        for key, value in item.items():
            setattr(self, f'_{key}', value)
            
    def __save(self):
        if not self._ismodified:
            return
        
        cursor = self.conn.cursor(cursor_factory=DictCursor)
        if self.id:
            cursor.execute(
                f'UPDATE TABLE "item"'
                f' SET category_id = \'{self.category_id}\''
                f' title = \'{self.title}\''
                f' price = \'{self.price}\''
                f' WHERE id = {self.id}'
            )
        else:
            cursor.execute(
                f'INSERT INTO "item" (category_id, title, price)'
                f' VALUES ({self.category_id}, \'{self.title}\', {self.price}) RETURNING id'
            )
            self._id = cursor.fetchone()['id']
            
        cursor.close()
        
    def save(self):
        self.__save()


import ipdb
ipdb.set_trace()
