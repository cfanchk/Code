
// OpticalFlowMFCDlg.h : 头文件
//

#pragma once
#include "svm.h"
#include "opencv\cv.h"
#include "opencv\highgui.h"
#include "CvvImage.h"

// COpticalFlowMFCDlg 对话框
class COpticalFlowMFCDlg : public CDialogEx
{
// 构造
public:
	COpticalFlowMFCDlg(CWnd* pParent = NULL);	// 标准构造函数

// 对话框数据
	enum { IDD = IDD_OPTICALFLOWMFC_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV 支持


// 实现
protected:
	HICON m_hIcon;

	// 生成的消息映射函数
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()

public:
	bool isInitialize;

	afx_msg void DrawPicToHDC(IplImage *img, UINT ID);
	afx_msg void write2file(float* data, std::ofstream& outfile);
	afx_msg void copyOpticalData(const cv::Mat& flow, cv::Mat& u, cv::Mat& v);
	afx_msg void calFeature(float* matrix, svm_node* x, const float* meanVector, int product);
	afx_msg void calFeatureTrain(float* matrix, float* featureVector, const float* meanVector, int product);
	afx_msg bool isAbnormal(cv::Mat& frame, cv::Mat& preframe, svm_model* x);
	afx_msg void calFeatureFun(cv::Mat& frame, cv::Mat& preframe, std::ofstream& outfile);
	afx_msg int GetState();

	afx_msg void OnBnClickedCancel();
	afx_msg void OnBnClickedOk();
	afx_msg void OnBnClickedClose();
	afx_msg void OnBnClickedCheck();
};
