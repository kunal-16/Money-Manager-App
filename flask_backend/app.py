import flask
from flask import request, jsonify
from flask_restful import Resource, Api
from flask_sqlalchemy import SQLAlchemy

app =flask.Flask(__name__)
# app.config["DEBUG"]=True
app.config["SQLALCHEMY_DATABASE_URI"]='sqlite:///site.db'

db=SQLAlchemy(app)

class User(db.Model):
    id=db.Column(db.Integer, primary_key=True)
    username=db.Column(db.String(20), unique=True, nullable=False)
    password=db.Column(db.String(60), unique=False, nullable=False)

    def __str__(self):
        return f"User('{self.username}', '{str(self.id)}')"

class Group(db.Model):
    grpCode=db.Column(db.Integer, primary_key=True, nullable=False, unique=True)
    grpName=db.Column(db.String(50), unique=False, nullable=False)

    def __str__(self):
        return f"Group('{self.grpCode}', '{self.grpName}')"

class User_Group(db.Model):
    id=db.Column(db.Integer, primary_key=True)
    userId=db.Column(db.Integer, db.ForeignKey('user.id'))
    grpCode=db.Column(db.Integer, db.ForeignKey('group.grpCode'))
    grpName=db.Column(db.String(20), nullable=False, unique=False)
    paid=db.Column(db.Float, unique=False, nullable=False, default=0)
    toBePaid=db.Column(db.Float, unique=False, nullable=False, default=0)
    user = db.relationship("User", backref=db.backref("user", uselist=False))
    group = db.relationship("Group", backref=db.backref("group", uselist=False))

    def __str__(self):
        return f"Group('{self.id}', '{self.userId}', '{self.grpCode}', '{self.paid}')"



api=Api(app)

# books = [
#     {'id': 0,
#      'title': 'A Fire Upon the Deep',
#      'author': 'Vernor Vinge',
#      'first_sentence': 'The coldsleep itself was dreamless.',
#      'year_published': '1992'},
#     {'id': 1,
#      'title': 'The Ones Who Walk Away From Omelas',
#      'author': 'Ursula K. Le Guin',
#      'first_sentence': 'With a clamor of bells that set the swallows soaring, the Festival of Summer came to the city Omelas, bright-towered by the sea.',
#      'published': '1973'},
#     {'id': 2,
#      'title': 'Dhalgren',
#      'author': 'Samuel R. Delany',
#      'first_sentence': 'to wound the autumnal city.',
#      'published': '1975'}
# ]

# class GetAllBooks(Resource):
#     def __init__(self):
#         pass

#     def get(self):
#         return jsonify(books)
# class GetBook(Resource):
#     def __init__(self):
#         pass
    
#     def get(self):
#         if 'id' in request.args:
#             id=int(request.args['id'])
#         else:
#             return 'no id'
    
#         for book in books:
#             if book['id']==id:
#                 return jsonify(book)
class GetGroupMembers(Resource):
    
    def __init__(self):
        pass

    def get(self):
        if 'grpcode' in request.args:
            grpCode=int(request.args['grpcode'])
            usergroup=[]
            usergroup=list(User_Group.query.filter_by(grpCode=grpCode))
            memberList=[]
            for obj in usergroup:
                userdict={}
                userdict['userId']=obj.userId
                userdict['username']=User.query.filter_by(id=obj.userId).first().username
                userdict['paid']=obj.paid
                userdict['toBePaid']=obj.toBePaid
                memberList.append(userdict)
            return jsonify(memberList)
            

class AddTransaction(Resource):
    def __init__(self):
        pass

    def get(self):
        grpCode=int(request.args['grpcode'])
        username=request.args['username']
        amount=float(request.args['amount'])
        userId=User.query.filter_by(username=username).first().id
        usergroup=User_Group.query.filter_by(userId=userId, grpCode=grpCode).first()
        usergroup.paid=usergroup.paid+amount
        db.session.commit()
        usergroupList=list(User_Group.query.filter_by(grpCode=grpCode))
        sum=float(0)
        for obj in usergroupList:
            sum=obj.paid+sum
        avg=sum/len(usergroupList)
        for obj in usergroupList:
            if obj.paid>avg:
                obj.toBePaid=obj.paid-avg
                db.session.commit()
            if obj.paid<avg:
                obj.toBePaid=0
                db.session.commit()
        return jsonify({'status': 'Success'})


        
        



class GetUserGroups(Resource):
    def __init__(self):
        pass

    def get(self):
        if 'username' in request.args:
            username=request.args['username']
            user=User.query.filter_by(username=username).first()
            userId=user.id
            userGrpObjects=User_Group.query.filter_by(userId=userId)
            
            grpList=[]
            for obj in userGrpObjects:
                objDict={}
                
                objDict['id']=obj.id
                objDict['userId']=obj.userId
                objDict['grpCode']=obj.grpCode
                
                objDict['grpName']=obj.grpName
                
                grpList.append(objDict)
            return jsonify(grpList)
            


            # grpList=[]
            # for usergrp in userGrpList:
            #     grpList.append(usergrp.grpCode)
            # return jsonify({'list':grpList})

class JoinGroup(Resource):
    def __init__(self):
        pass

    def get(self):
        
        if 'grpcode' in request.args:
            grpCode=int(request.args['grpcode'])
            
            username=request.args['username']
            user=User.query.filter_by(username=username).first()
            exists=False
            for x in list(User_Group.query.filter_by(userId=user.id)):
                if x.grpCode==grpCode:
                    exists=True
            if exists==True:
                return jsonify({'status':'Already In The Group'})

            # if User_Group.query.filter_by(userId=user.id).first()!=None:
            #     if User_Group.query.filter_by(userId=user.id).first().grpCode==grpCode:
            #         return jsonify({'status':'Already In The Group'})
            group=Group.query.filter_by(grpCode=grpCode).first()
            if group!=None:
                usergroup = User_Group(userId=user.id, grpCode=group.grpCode, grpName=group.grpName)
                db.session.add(usergroup)
                db.session.commit()
                return jsonify({'status': 'Joined Group'})

            else:
                return jsonify({'status': 'Group Doesnt Exist'})


class CheckGroup(Resource):
    def __init__(self):
        pass 

    def get(self):
        if 'grpcode'in request.args:
            grpCode=int(request.args['grpcode'])
            if Group.query.filter_by(grpCode=grpCode).first() == None:
                return jsonify({'status':'Success'})
            else:
                return jsonify({'status':'Failure'})



class CreateGroup(Resource):
    def __init__(self):
        pass

    def get(self):
        if 'username' in request.args:
            username=str(request.args['username'])
            grpCode=int(request.args['grpcode'])
            
            grpName=str(request.args['grpname'])
            user=User.query.filter_by(username=username).first()
            
            grp = Group.query.filter_by(grpCode=grpCode).first()
            
            if grp == None:
                #create grp
                
                newgrp = Group(grpCode=grpCode, grpName=grpName)
                db.session.add(newgrp)
                db.session.commit()
                usergrp=User_Group(userId=user.id, grpCode=grpCode, grpName=grpName)
                db.session.add(usergrp)
                db.session.commit()
                return jsonify({'status': 'Group Created'})
            else:
                return jsonify({'status': 'Group Already Exists'})
        else:
            return jsonify({'status': 'Error'})

class CheckLogin(Resource):

    def __init__(self):
        pass

    def get(self):
        if 'username' in request.args:
            username=str(request.args['username'])
            password=str(request.args['password'])
            user=User.query.filter_by(username=username).first()
            if user:
                if user.password==password:
                    return jsonify({'status': 'Login Success'})
                else:
                    return jsonify({'status': 'Wrong Credentials'})    
            else:
                return jsonify({'status': 'Wrong Credentials'}) 

class Register(Resource):
    def __init__(self):
        pass

    def get(self):
        if 'username' in request.args:
            username=str(request.args['username'])
            password=str(request.args['password'])
            if User.query.filter_by(username=username).first():
                return jsonify({'status' : 'Username Taken'})
            userCreated=User(username=username, password=password)
            db.session.add(userCreated)
            db.session.commit()
            return jsonify({'status' : 'User Created'})



# @app.route('/allbooks', methods=['GET'])
# def allBooks():
#     return jsonify(books)

# @app.route('/getbook', methods=['GET'])
# def getBook():

#     if 'id' in request.args:
#         id=int(request.args['id'])
#     else:
#         return 'no id'
    
#     for book in books:
#         if book['id']==id:
#             return jsonify(book)

# # api.add_resource(GetBook, '/getbook')
# api.add_resource(GetAllBooks, '/allbooks')
api.add_resource(CheckLogin, '/checklogin')
api.add_resource(Register, '/register')
api.add_resource(CreateGroup, '/creategroup')
api.add_resource(CheckGroup, '/checkgroup')
api.add_resource(GetUserGroups, '/getusergroups')
api.add_resource(JoinGroup, '/joingroup')
api.add_resource(GetGroupMembers, '/getgroupmembers')
api.add_resource(AddTransaction, '/addtransaction')

if __name__=='__main__':
    app.run(debug=True)