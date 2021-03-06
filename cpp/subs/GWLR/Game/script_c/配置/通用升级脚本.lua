加载配置脚本文件("通用配置.lua")
加载配置脚本文件("任务处理映射.lua")
------------------------------------------------------------------------------------------------------------------------------
--默认不会进入每个副本后采集一些东西
--要采集的东西，请去 通用配置.lua 里搜索这几个关键字，那里有详细说明：通用_需要进入副本后采集一些东西、通用_进入副本后采集一些东西
--如果你想进入副本后采集一些东西，你可以在下面这一条指令前面加上注释（注释就是这两个字符：--），即：--通用_需要进入副本后采集一些东西 = 假
通用_需要进入副本后采集一些东西 = 假
--默认先主线再去打派生武器所需材料，如果想先去打派生武器所需材料，就把下面的 假 改为 真
先去打派生武器所需材料 = 假
--默认先主线再打悬赏，如果想先悬赏，就把下面的 假 改为 真
先打悬赏再做主线 = 假
--默认先主线再打喵喵副本，如果想先打喵喵副本，就把下面的 假 改为 真
先打喵喵副本再做主线 = 假
--默认先主线再打王立副本，如果想先打王立副本，就把下面的 假 改为 真
先打王立副本再做主线 = 假
--默认先主线再打王立精英副本，如果想先打王立精英副本，就把下面的 假 改为 真
先打王立精英副本再做主线 = 假
--默认角色满级了，也会去做主线。但假如角色等级大于等于40级，不想去做主线了，只想去刷赏金、喵喵副本、王立副本等，可以把下面这个数值由默认的60改为40
不去做主线时的角色等级 = 60
--如果你想角色进入游戏后就邮寄一次，就把下面的 假 改为 真
角色进入游戏后就邮寄一次 = 假
------------------------------------------------------------------------------------------------------------------------------
--*******************这里的变量，你不需要管**********************
进入游戏后只执行一次标记 = 假
------------------------------------------------------------------------------------------------------------------------------
--*******************你想单独定义的函数或变量请在这里搞，想查看定义方式就去看自带的函数或变量的定义，然后复制粘贴，还有不明白的就去看 通用配置.lua开头处的详细说明*******************
通用配置_特殊的配置数据()
---------------------------------------------------------------
--*******************这里的变量，你不需要管**********************
局部变量 接, 做, 提交 = 假, 假, 假
局部变量 打主线失败次数 = 0
局部变量 打第一个副本次数 = 0
局部变量 自动获取当前武器材料计数 = 0
---------------------------------------------------------------
--想要决定什么时候换角色，请在这里搞，返回 真 就会换号，返回 假 不会换号
定义函数 需要中断处理任务()
	局部变量 当前的角色等级 = 角色等级()
	--角色不满级的时候，才会去判断剩余单倍经验和剩余双倍经验
	如果 当前的角色等级 < 50 那么
		--剩余单倍经验和剩余双倍经验同时小于等于0的时候，就会返回 真，就会换号
		如果 剩余单倍经验() <= 0 且 剩余双倍经验() <= 0 那么
			返回 真
		结束
	结束

	--如果 剩余狩猎券() <= 0 那么
		--返回 真
	--结束

	--此函数用来判断换角色
	如果 得到当前有效的副本消费模式() < 0 那么
		返回 真
	结束

	--如果你想根据等级来判断何时该换角色的话，请在下面调整其数值
	如果 当前的角色等级 >= 50 那么
		返回 真
	结束
	返回 假
结束

定义函数 中断处理任务前的处理()
	通用_普通号进行当面交易()

	通用配置_处理一次邮寄()

	设置疲劳值(0)
	返回 换角色()
结束

--做主线的时候，想要做些其他事的话，请在这里搞
定义函数 主线不正常后的处理()
	---------------------------------------------------------------------------------------------
	--在做任务的时候会做下面的事情，可凭喜好自由改写。可自由调整它们的位置，也可自由注释掉一些行为。
	--先做悬赏任务
	如果 通用_智能做一个悬赏任务() 那么
		返回 真
	结束

	--再去打喵喵副本
	如果 通用_智能做一个喵喵副本() 那么
		返回 真
	结束

	--再去打王立副本
	如果 通用_智能做一个王立副本() 那么
		返回 真
	结束

	--再去打王立精英副本
	如果 通用_智能做一个王立精英副本() 那么
		返回 真
	结束

	--再去获取材料
	自动去获取当前武器所需材料()
	--如果 自动去获取当前武器所需材料() > 0 那么
		--返回 真
	--结束
	自动穿戴一些装备(4, 真)

	--再去打最高等级的副本
	如果 通用_杀死指定副本的BOSS(获取合适等级的副本名()) 那么
		返回 真
	结束

	通用_购买一些采集所需物品()
	--再去自动采集并打副本，默认采集所有采集物
	如果 通用_采集并打指定的副本(获取合适等级的副本名(), 空) > 0 那么
		返回 真
	结束
	--想要采集指定的采集物，可在此配置，并取消注释（别忘把上面 通用_采集并打指定的副本 给注释咯）
	--如果 通用_采集并打指定的副本(获取合适等级的副本名(), { "矿", "虫", "草", "蘑菇", "网", "骨堆", "鱼" }) > 0 那么
		--返回 真
	--结束

	--这里的打 挑战！大野猪王 与下面的试练！大野猪王是相互配合配置的，此处会优先打一次下面的试练！大野猪王，解锁后就全都打挑战！大野猪王
	--配置A处要写成挑战副本，配置B处写成试练副本，位置不要弄错哦
	如果 打第一个副本次数 > 0 那么
		如果 通用_杀死指定副本的BOSS("挑战！大野猪王") 那么		--配置A
			返回 真
		结束
	结束
	--再去打你想要打的副本，想去打哪个就填哪个副本名。如果你想打多个副本，可在后面照此添加
	如果 通用_杀死指定副本的BOSS("试练！大野猪王") 那么			--配置B
		打第一个副本次数 = 打第一个副本次数 + 1
		返回 真
	结束
	---------------------------------------------------------------------------------------------
	返回 假
结束

定义函数 进入游戏后只执行一次()
	如果 进入游戏后只执行一次标记 == 真 那么
		返回
	结束
	通用_初始化一次任务处理()

	进入游戏后只执行一次标记 = 真
结束

--这个函数根据当前角色等级与当前武器的角色等级的差距来判断什么时候该去自动获取当前武器的材料
--第一个参数是次数上限
--第二个参数是等级差距上限
定义函数 判断是否到了该自动获取当前武器材料( 次数上限, 等级差距上限 )
	局部变量 武器角色等级 = 得到物品角色等级(获取当前所穿武器())
	局部变量 我的角色等级 = 角色等级()
	局部变量 等级差距 = 我的角色等级 - 武器角色等级
	如果 等级差距 >= 等级差距上限 那么
		自动获取当前武器材料计数 = 自动获取当前武器材料计数 + 1
		如果 自动获取当前武器材料计数 >= 次数上限 那么
			--重置计数
			自动获取当前武器材料计数 = 0
			返回 真
		结束
	结束
	返回 假
结束

--如果想中止循环就返回假，否则返回真
定义函数 每次循环所做的事()
	如果 需要中断处理任务() 那么
		如果 中断处理任务前的处理() 那么
			返回 假
		否则
			返回 真
		结束
	结束

	接, 做, 提交 = 假, 假, 假

	局部变量 当前等级 = 角色等级()
	如果 当前等级 > 20 那么
		通用_购买一些打怪所需物品()
	结束
	如果 通用_需要进入副本后采集一些东西 == 真 那么
		通用_购买一些采集所需物品()
	结束


	通用_领取狩猎券()
	--自动穿戴一些装备，只穿戴小于等于参数指定的品质的装备
	--第一个参数是物品品质上限，数字类型，不可为空，必须是从1到8之间，依次表示：白色、绿色、淡玫红、蓝色、深玫红、紫色、橘黄色、金黄色
	--第二个参数是个布尔型，可为空，表示是否需要先去获取装备所需材料，或者说是否要去打造一些装备或武器，为空即为假
	自动穿戴一些装备(4, 假)
	--只是去自动升级身上装备而已，若材料不足，并不会自动去获取材料
	通用_自动升级身上装备()
	购买一些对方阵营的拍卖物品()
	通用_处理拍卖行()
	--想要使用一些物品，就是在 通用_处理礼包 这个函数里添加，请在 通用功能.lua里搜 通用_处理礼包
	通用_处理礼包()
	存放一些背包物品到仓库(100)
	卖掉仓库和背包的垃圾物品(8, 10, "希美伦山路", "流浪的斯通")

	如果 先打悬赏再做主线 那么
		做 = 通用_智能做一个悬赏任务()
	结束

	--判断是否到了该自动获取当前武器材料(3, 10)->当前角色等级与当前武器角色等级的差距大于等级10，并且重复次数大于等于3次以上，会去自动获取当前武器所需材料一次。
	如果 做 ~= 真 且 先去打派生武器所需材料 或 判断是否到了该自动获取当前武器材料(3, 10) 那么
		--只会去获取 添加自动穿戴装备白名单 命令添加的装备所需的材料。即当前武器不在白名单中，是不去会获取当前武器所需材料的。
		做 = 自动去获取当前武器所需材料() > 0
	结束

	如果 做 ~= 真 且 先打喵喵副本再做主线 那么
		做 = 通用_智能做一个喵喵副本()
	结束

	如果 做 ~= 真 且 先打王立副本再做主线 那么
		做 = 通用_智能做一个王立副本()
	结束

	如果 做 ~= 真 且 先打王立精英副本再做主线 那么
		做 = 通用_智能做一个王立精英副本()
	结束

	----------------------------------------------------------
	--下面这段代码是做主线，不想做主线就把它们注释掉
	如果 当前等级 < 不去做主线时的角色等级 那么
		如果 做 ~= 真 那么
			接 = 接一个可接的任务()
			延迟(1000)
			做 = 做一个未完成的任务()
			延迟(1000)
			提交 = 提交一个已完成的任务()
		结束
	结束
	----------------------------------------------------------

	如果 不 接 且 不 做 且 不 提交 那么
		打主线失败次数 = 打主线失败次数 + 1

		如果 当前等级 < 不去做主线时的角色等级 那么
			LuaLogW("接一个任务、做一个任务和提交一个任务均失败，请关注Dbgview里的LOG输出信息，用以排查错误")
			如果 打主线失败次数 >= 2 那么
				主线不正常后的处理()
				打主线失败次数 = 0
			结束
		否则
			主线不正常后的处理()
		结束
	否则
		打主线失败次数 = 0
	结束

	返回 真
结束

定义函数 处理任务()
	如果 是新创建的角色() 那么
		做_梦的起点()
	结束

	如果 角色进入游戏后就邮寄一次 == 真 那么
		通用配置_处理一次邮寄()
	结束

	-------------------------------------------------------------------------------------
	--重置变量
	打主线失败次数 = 0
	打第一个副本次数 = 0
	自动获取当前武器材料计数 = 0
	通用配置_重置所有高级副本的辅助变量()
	-------------------------------------------------------------------------------------
	通用_处理进入角色后的每次循环(每次循环所做的事)
结束

返回 定义函数() 通用_主逻辑循环(进入游戏后只执行一次, 处理任务) 结束
