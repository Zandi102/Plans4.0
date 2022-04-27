import Foundation

class User : Identifiable {
    
    private struct UserStruct: Decodable {
        enum Category: String, Decodable{
            case swift, combine, debugging, xcode
        }
        let username: String
        let phone: String
        let age: String
        let password: String
        let name: String
        let description: String
    }
    
    private struct FriendStruct: Decodable {
        enum Category: String, Decodable{
            case swift, combine, debugging, xcode
        }
        let username2: String
        let name: String
    }
    
    private struct PlanStruct: Decodable {
        enum Category: String, Decodable{
            case swift, combine, debugging, xcode
        }
        let plan_id : String
        let plan_name: String
        
        let endTime : String
        let startTime: String
        
        let date: String
        let description: String
        
        let username: String
        
        let address: String
        
    }
    
    private struct BasicUserStruct: Decodable {
        enum Category: String, Decodable{
            case swift, combine, debugging, xcode
        }
        let username: String
        let name: String
    }
    
    public var fullName : String // full title in the format of "(First) (Last)" otherwise error
    public var userName : String
    private var phone : Int
    private var age : Int
    public var password : String
    public var description : String
    public var plans : [Plan] = []
    public var userPlans : [Plan] = []
    public var friends : [User] = []
    public var invites : [User] = []
    public var isAdded : Int = 0
    private static var usernameFound = false;
    private static var invitesFound = false;
    private static var friendsFound = false;
    // private var timeZone : TimeZone = TimeZone.autoupdatingCurrent
    // private var calender : Calendar = Calendar.autoupdatingCurrent
    init() {
        self.fullName = ""
        self.userName = ""
        self.phone = 0
        self.age = 0
        self.password = ""
        self.description = ""
    }
    
    init?(_ username : String) {
        let db = DBManager();
        let url = URL(string: "http://abdasalaam.com/Functions/loadUser.php?username=\(username)")!
        let messages = db.getRequest(url)
        if messages.count > 0 {
            let userFields = messages[0]
            print("In User Class")
            print(userFields)
            let jsonData = userFields.data(using: .utf8)!
            let resp: UserStruct = try! JSONDecoder().decode(UserStruct.self, from: jsonData);
            self.fullName = resp.name
            self.userName = resp.username
            self.phone = 0
            self.age = 0
            self.password = resp.password
            self.description = resp.description
        }
        else {
            return nil
        }
     }
    
    public static func createCurrentUser(_ username : String) -> User {
        let user : User = User();
        let db = DBManager();
        let url = URL(string: "http://abdasalaam.com/Functions/loadUser.php?username=\(username)")!
        let messages = db.getRequest(url)
        if messages.count > 0 {
            let userFields = messages[0]
            print("In User Class")
            print(userFields)
            let jsonData = userFields.data(using: .utf8)!
            let resp: UserStruct = try! JSONDecoder().decode(UserStruct.self, from: jsonData);
            user.fullName = resp.name
            user.userName = resp.username
            user.phone = 0
            user.age = 0
            user.password = resp.password
            user.description = resp.description
            User.usernameFound = true
            if User.usernameFound == true {
                user.setFriends(username: username)
            }
            if User.usernameFound == true && User.friendsFound == true {
                user.setInvites(username: username)
            }
            if User.invitesFound == true && User.friendsFound == true && User.usernameFound == true {
                user.setPlans(username: username)
            }
        }
        return user;
    }
    
    init(fullName : String, userName : String, email : String, phone : Int, age : Int, password : String) {
        self.fullName = fullName
        self.userName = userName
        self.phone = phone
        self.age = age
        self.password = password
        self.description = ""
    }
    
    init(userName : String, password : String) {
        self.fullName = ""
        self.userName = userName
        self.phone = 0
        self.age = 0
        self.password = password
        self.description = ""
    }
    
    private init(fullName : String, userName : String, email : String, phone : Int, age : Int, password : String, plans: [Plan]) {
        self.fullName = fullName
        self.userName = userName
        self.phone = phone
        self.age = age
        self.password = password
        self.plans = plans
        self.description = ""
    }
    
    init(username: String, name: String) {
        self.fullName = name
        self.userName = username
        self.phone = 0
        self.age = 0
        self.password = ""
        self.description = ""
    }
    
    private init(fullName : String, userName : String, email : String, phone : Int, age : Int, password : String, friends : [User]) {
        self.fullName = fullName
        self.userName = userName
        self.description = ""
        self.phone = phone
        self.age = age
        self.password = password
        self.friends = friends
        for friend in friends {
            for friendPlan in friend.plans {
                self.plans.append(friendPlan)
            }
        }
    }
    
    // adding a plan to the plan list
    func addPlan(_ plan: Plan) -> User {
        for friend in friends {
            plan.attendees?.append(friend)
        }
        for friend in friends {
            friend.plans.append(plan)
        }
        plans.append(plan)
        return self
    }
    
    // .equals override in swift
    static func == (lhs: User, rhs: User) -> Bool {
        if (lhs.userName == rhs.userName) {
            return true
        }
        else {
            return false
        }
    }
    
    private func setFriends(username : String) {
        let db = DBManager();
        let url = URL(string: "http://abdasalaam.com/Functions/loadFriends.php?username=\(username)")!
        let messages = db.getRequest(url)
        self.friends = [User]()
        //message will contain the username and the name of friends that have isAdded = 1 for the corresponing user
        if messages.count > 0 {
            for message in messages {
                print("In User Class loading Friends")
                print(message)
                let jsonData = message.data(using: .utf8)!
                let resp: FriendStruct = try! JSONDecoder().decode(FriendStruct.self, from: jsonData);
                friends.append(User(username: resp.username2, name: resp.name))
                User.friendsFound = true;
            }
        }
        else {
            print("No friends Found")
        }
    }

    private func setInvites(username : String) {
        let db = DBManager();
        let url = URL(string: "http://abdasalaam.com/Functions/loadPendingFriends.php?username=\(username)")!
        let messages = db.getRequest(url)
        self.invites = [User]()
        //message will contain the username and the name of friends that have isAdded = 1 for the corresponing user
        if messages.count > 0 {
            for message in messages {
                print("In User Class")
                print(message)
                let jsonData = message.data(using: .utf8)!
                let resp: FriendStruct = try! JSONDecoder().decode(FriendStruct.self, from: jsonData);
                invites.append(User(username: resp.username2, name: resp.name))
                User.invitesFound = true;
            }
        }
        else {
            print("No friends Found")
        }
    }
    
    private func setPlans(username : String) {
        let db = DBManager();
        let url = URL(string: "http://abdasalaam.com/Functions/loadFriendPlans.php?username=\(username)")!
        let url2 = URL(string: "http://abdasalaam.com/Functions/loadUserPlans.php?username=\(username)")!
        let messages = db.getRequest(url)
        let messages2 = db.getRequest(url2)
        self.plans = [Plan]();
        if messages.count > 0 {
            for message in messages {
                print("In Plan Class")
                print(message)
                let jsonData = message.data(using: .utf8)!
                //print(jsonData3)
                let resp: PlanStruct = try! JSONDecoder().decode(PlanStruct.self, from: jsonData);
                print(resp.plan_name)
                plans.append(Plan(title: resp.plan_name, day:Plan.textToDate(resp.date), startTime: Plan.textToTime(resp.startTime), endTime:Plan.textToTime(resp.endTime), address: resp.address, notes: resp.description, ownerUsername: resp.username))
            }
        }
        if messages2.count > 0 {
            for message2 in messages2 {
                print("In Plan Class")
                print(message2)
                let jsonData2 = message2.data(using: .utf8)!
                //print(jsonData3)
                let resp: PlanStruct = try! JSONDecoder().decode(PlanStruct.self, from: jsonData2);
                print(resp.plan_name)
                plans.append(Plan(title: resp.plan_name, day:Plan.textToDate(resp.date), startTime: Plan.textToTime(resp.startTime), endTime:Plan.textToTime(resp.endTime), address: resp.address, notes: resp.description, ownerUsername: resp.username))
            }
        }
        else {
            print("No Plans Found")
        }
    }


}
#if DEBUG
extension User {
    private static var friend1  = User(fullName: "Jack Torres", userName: "jack2012", email: "jack@mail.com", phone: 2345678901, age: 21, password: "password123").addPlan(
        Plan(title: "Dinner at Piada",
             startTime: Date().addingTimeInterval(2500.0),
             endTime: Date().addingTimeInterval(5000.0),
             address: "13947 Cedar Rd, South Euclid, OH, 44118",
             notes: "")).addPlan(
        Plan(title: "go to the movies",
            startTime: Date().addingTimeInterval(5000.0),
            endTime: Date().addingTimeInterval(7500.00),
            address: "2163 Lee Rd, Cleveland Heights, OH 44118",
            notes: "drama preferred")).addPlan(
        Plan(title: "clubbin at barley",
             startTime: Date().addingTimeInterval(7000.0),
             endTime: Date().addingTimeInterval(9000.0),
             address: "1261 W 6th St, Cleveland, OH 44113",
             notes: ""))
    private static var friend2  = User(fullName: "Frank Miller", userName: "frankie2005", email: "frankie@mail.com", phone: 4567890123, age: 21, password: "password123").addPlan(
        Plan(title: "fiji rave",
             startTime: Date().addingTimeInterval(4550.0),
             endTime: Date().addingTimeInterval(6000.0),
             address: "11317 Bellflower Rd, Cleveland, OH, 44106",
             notes: "make sure to register before")).addPlan(
        Plan(title: "BEACH!",
            startTime: Date().addingTimeInterval(18000.0),
            endTime: Date().addingTimeInterval(24000.0),
            address: "Lakewood",
            notes: "bring trunks!"))
    private static var friend3  = User(fullName: "Eddie Johnson", userName: "eddie01", email: "eddie01@mail.com", phone: 5678901234, age: 21, password: "password123").addPlan(
        Plan(title: "Movie Night",
             startTime: Date().addingTimeInterval(24300.0),
             endTime: Date().addingTimeInterval(32300.0),
             address: "SmAprtmt",
             notes: "popcorn needed")).addPlan(
        Plan(title: "Study Sesh",
             startTime: Date().addingTimeInterval(42000),
             endTime: Date().addingTimeInterval(45000),
             address: "library",
             notes: "")).addPlan(
        Plan(title: "To the mall",
             startTime: Date().addingTimeInterval(15100.0),
             endTime: Date().addingTimeInterval(15100.0),
             address: "beachwood mall",
             notes: "the mall"))
    private static var friend4  = User(fullName: "Mark Zuckerberg", userName: "markFacebook!!", email: "markZ@gmail.com", phone: 2848328834, age: 21, password: "password123").addPlan(
        Plan(title: "Dinner at Piada",
             startTime: Date().addingTimeInterval(2500.0),
             endTime: Date().addingTimeInterval(5000.0),
             address: "13947 Cedar Rd, South Euclid, OH, 44118",
             notes: "")).addPlan(
        Plan(title: "go to the movies",
            startTime: Date().addingTimeInterval(5000.0),
            endTime: Date().addingTimeInterval(7500.00),
            address: "2163 Lee Rd, Cleveland Heights, OH 44118",
            notes: "drama preferred")).addPlan(
        Plan(title: "clubbin at barley",
             startTime: Date().addingTimeInterval(7000.0),
             endTime: Date().addingTimeInterval(9000.0),
             address: "1261 W 6th St, Cleveland, OH 44113",
             notes: ""))
    private static var friend5  = User(fullName: "Helen Molteini", userName: "hlm35", email: "helenmolteini@gmail.com", phone: 2848328834, age: 21, password: "chicken").addPlan(
        Plan(title: "Dinner at Piada",
             startTime: Date().addingTimeInterval(2500.0),
             endTime: Date().addingTimeInterval(5000.0),
             address: "13947 Cedar Rd, South Euclid, OH, 44118",
             notes: "")).addPlan(
        Plan(title: "go to the movies",
            startTime: Date().addingTimeInterval(5000.0),
            endTime: Date().addingTimeInterval(7500.00),
            address: "2163 Lee Rd, Cleveland Heights, OH 44118",
            notes: "drama preferred")).addPlan(
        Plan(title: "clubbin at barley",
             startTime: Date().addingTimeInterval(7000.0),
             endTime: Date().addingTimeInterval(9000.0),
             address: "1261 W 6th St, Cleveland, OH 44113",
             notes: ""))

    // sample friends list
    public static var sampleFriendList = [friend1, friend2, friend3, friend4, friend5];
    
    private static func allFriends() -> [User]{
        var users : [User] = []
        let db = DBManager();
        let url = URL(string: "http://abdasalaam.com/Functions/loadUsers.php")!
        let messages = db.getRequest(url)
        //message will contain the username and the name of friends that have isAdded = 1 for the corresponing user
        if messages.count > 0 {
            for message in messages {
                let jsonData = message.data(using: .utf8)!
                let resp: BasicUserStruct = try! JSONDecoder().decode(BasicUserStruct.self, from: jsonData);
                users.append(User(username: resp.username, name: resp.name))
            }
        }
        return users
    }
    
    public static var allUsers = allFriends()
    
    // sample test user with existing plans and existing friends
    static var sampleUser = User(userName: "Hi", password: "Hi");
    
    
    public func setUsername(username:String) {
        self.userName = username;
        self.setFriends(username: username)
    }
    public func setPassword(password:String) {
        self.password = password;
    }
    public func setFullName(fullName:String) {
        self.fullName = fullName;
    }
    
    public func addFriend(user: User) {
        self.friends.append(user)
    }
    
    public func removeInvite(username: String) {
        var count = 0
        for invite in invites {
            if invite.userName == username {
                invites.remove(at: count)
                break
            }
            count += 1;
        }
    }
}
#endif