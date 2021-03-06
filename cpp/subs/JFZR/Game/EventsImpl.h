#pragma once
/*
@author zhp
@date 2014/9/13 19:31
@purpose for events impl
*/
#include <Common/CmnEvent.h>

class CmnEventsMgr_Impl : public CmnEventsMgr{
public:
	CmnEventsMgr_Impl( lua_State* lua_state );

public:
	void ResetFailedDoTaskCnt();

private:
	void LoadProtoEvents();

private:
	int				failed_do_task_cnt_;
};

class CmnEventsFatory_Impl : public CmnEventsFatory{
public:
	CmnEventsFatory_Impl( lua_State* lua_state );
	CmnEventsMgr* CreateEventsMgr();

private:
	lua_State*	lua_state_;
};