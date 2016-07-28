
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
	
	void DrawPicToHDC(IplImage *img, UINT ID);
	void write2file(float* data, std::ofstream& outfile);
	void copyOpticalData(const cv::Mat& flow, cv::Mat& u, cv::Mat& v);
	void calFeature(float* matrix, svm_node* x, const float* meanVector, int product);
	void calFeatureTrain(float* matrix, float* featureVector, const float* meanVector, int product);
	bool isAbnormal(cv::Mat& frame, cv::Mat& preframe, svm_model* x);
	void calFeatureFun(cv::Mat& frame, cv::Mat& preframe, std::ofstream& outfile);
	int GetState();

	static UINT Thread1(void *param);
	bool play_flag;

	afx_msg void OnBnClickedCancel();
	afx_msg void OnBnClickedOk();
	afx_msg void OnBnClickedClose();
	afx_msg void OnBnClickedCheck();
};
