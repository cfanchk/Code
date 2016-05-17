
// OpticalFlowMFCDlg.h : ͷ�ļ�
//

#pragma once
#include "svm.h"
#include "opencv\cv.h"
#include "opencv\highgui.h"
#include "CvvImage.h"

// COpticalFlowMFCDlg �Ի���
class COpticalFlowMFCDlg : public CDialogEx
{
// ����
public:
	COpticalFlowMFCDlg(CWnd* pParent = NULL);	// ��׼���캯��

// �Ի�������
	enum { IDD = IDD_OPTICALFLOWMFC_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV ֧��


// ʵ��
protected:
	HICON m_hIcon;

	// ���ɵ���Ϣӳ�亯��
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
