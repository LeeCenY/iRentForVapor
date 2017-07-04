import App
import MySQLProvider

//配置
let config = try Config()
try config.setup()
try config.addProvider(MySQLProvider.Provider.self)


let drop = try Droplet(config)
try drop.setup()

///数据库
let mysqlDriver = try drop.mysql()




try drop.run()
