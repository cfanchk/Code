
// OpticalFlowMFC.h : PROJECT_NAME Ӧ�ó������ͷ�ļ�
//

#pragma once

#ifndef __AFXWIN_H__
	#error "�ڰ������ļ�֮ǰ������stdafx.h�������� PCH �ļ�"
#endif

#include "resource.h"		// ������


// COpticalFlowMFCApp: 
// �йش����ʵ�֣������ OpticalFlowMFC.cpp
//

class COpticalFlowMFCApp : public CWinApp
{
public:
	COpticalFlowMFCApp();

// ��д
public:
	virtual BOOL InitInstance();

// ʵ��

	DECLARE_MESSAGE_MAP()
};

extern COpticalFlowMFCApp theApp;