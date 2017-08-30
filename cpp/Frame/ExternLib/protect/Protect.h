#pragma once
#include <config/targetver.h>

#ifdef __VMP__
#include "VMProtectSDK.h"
#endif

#ifdef UNICODE
#define VMProtectDecryptString VMProtectDecryptStringW
#else
#define VMProtectDecryptString VMProtectDecryptStringA
#endif

#ifdef __VMP__
template<typename CharT>
const CharT* VMProtectDecryptString_Helper_( const CharT* );
template<>
const char* VMProtectDecryptString_Helper_( const char* str );
template<>
const wchar_t* VMProtectDecryptString_Helper_( const wchar_t* str );
#endif

struct __VMProtectBegin__{
	__VMProtectBegin__( const char* str_id );
	~__VMProtectBegin__();
};
struct __VMProtectBeginUltra__{
	__VMProtectBeginUltra__( const char* str_id );
	~__VMProtectBeginUltra__();
};

#ifdef __VMP__
#ifdef _WIN64
#pragma comment(lib, "VMProtectSDK64.lib")
#else
#pragma comment(lib, "VMProtectSDK32.lib")
#endif

//��VM
#define VMP_BEGIN VMProtectBegin(__FUNCSIG__)
#define VMP_BEGIN_P(p) VMProtectBegin(p)
//����VM
#define VMP_BEGIN_EX VMProtectBeginUltra(__FUNCSIG__)
#define VMP_BEGIN_EX_P(p) VMProtectBeginUltra(p)
void __VMProtectEnd_HELPER__( int* );
#define VMP_END __VMProtectEnd_HELPER__(0), VMProtectEnd()
//�����ַ���
#define VMP_PROTECT_STR(procted_str)	VMProtectDecryptString_Helper_(procted_str)
#define VMP_PROTECT_STR_A(procted_str)	VMProtectDecryptStringA(procted_str)
#define VMP_PROTECT_STR_W(procted_str)	VMProtectDecryptStringW(procted_str)
//�õ���ǰ�Ļ�����
#define VMP_GET_CUR_HWID(buff, buff_len)	VMProtectGetCurrentHWID(buff, buff_len)
//scoped
#define VMP_BEGIN_SCOPE	__VMProtectBegin__(__FUNCSIG__)
#define VMP_BEGIN_SCOPE_EX	__VMProtectBeginUltra__(__FUNCSIG__)
#define VMP_IS_DEBUGGER() VMProtectIsDebuggerPresent(1)
#define VMP_CRC_VALID() VMProtectIsValidImageCRC()

#else
#define VMP_BEGIN	 (void*)0
#define VMP_BEGIN_P(p) (void*)0
#define VMP_BEGIN_EX	(void*)0
#define VMP_BEGIN_EX_P(p) (void*)0
#define VMP_END		(void*)0
#define VMP_PROTECT_STR(procted_str)	procted_str
#define VMP_PROTECT_STR_A(procted_str)	procted_str
#define VMP_PROTECT_STR_W(procted_str)	procted_str
#define	VMP_GET_CUR_HWID(buff, buff_len)	memset(buff, 'a', buff_len), buff[buff_len - 1] = 0
#define VMP_BEGIN_SCOPE	(void*)0
#define VMP_BEGIN_SCOPE_EX	(void*)0
#define VMP_IS_DEBUGGER() false
#define VMP_CRC_VALID() true
#endif

#ifdef __VMP__
template<>
inline const char* VMProtectDecryptString_Helper_( const char* str )
{
	return VMProtectDecryptStringA(str);
}

template<>
inline const wchar_t* VMProtectDecryptString_Helper_( const wchar_t* str )
{
	return VMProtectDecryptStringW(str);
}
#endif
inline void __VMProtectEnd_HELPER__( int* a ){
	int tmp = 0;
	a = (int*)((int)&tmp + (int)(void*)a);
	*a += 2;
}