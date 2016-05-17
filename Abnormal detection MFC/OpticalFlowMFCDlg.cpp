
// OpticalFlowMFCDlg.cpp : 实现文件
//

#include "stdafx.h"
#include "OpticalFlowMFC.h"
#include "OpticalFlowMFCDlg.h"
#include "afxdialogex.h"

#include <iostream>
#include <fstream>
#include "liblogm.h"
#include "mclmcr.h"
#include "matrix.h"
#include "mclcppclass.h"
#include "svm.h"
#include "cblas.h"
#include "opencv2\opencv.hpp"  

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// 用于应用程序“关于”菜单项的 CAboutDlg 对话框

class CAboutDlg : public CDialogEx
{
public:
	CAboutDlg();

// 对话框数据
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

// 实现
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialogEx(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialogEx)
END_MESSAGE_MAP()


// COpticalFlowMFCDlg 对话框



COpticalFlowMFCDlg::COpticalFlowMFCDlg(CWnd* pParent /*=NULL*/)
	: CDialogEx(COpticalFlowMFCDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void COpticalFlowMFCDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(COpticalFlowMFCDlg, CDialogEx)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDCANCEL, &COpticalFlowMFCDlg::OnBnClickedCancel)
	ON_BN_CLICKED(IDOK, &COpticalFlowMFCDlg::OnBnClickedOk)
	ON_BN_CLICKED(IDCLOSE, &COpticalFlowMFCDlg::OnBnClickedClose)
	ON_BN_CLICKED(IDC_CHECK, &COpticalFlowMFCDlg::OnBnClickedCheck)
END_MESSAGE_MAP()


// COpticalFlowMFCDlg 消息处理程序

BOOL COpticalFlowMFCDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// 将“关于...”菜单项添加到系统菜单中。

	// IDM_ABOUTBOX 必须在系统命令范围内。
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		BOOL bNameValid;
		CString strAboutMenu;
		bNameValid = strAboutMenu.LoadString(IDS_ABOUTBOX);
		ASSERT(bNameValid);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// 设置此对话框的图标。  当应用程序主窗口不是对话框时，框架将自动
	//  执行此操作
	SetIcon(m_hIcon, TRUE);			// 设置大图标
	SetIcon(m_hIcon, FALSE);		// 设置小图标

	// TODO:  在此添加额外的初始化代码
	((CButton *)GetDlgItem(IDC_RADIO1))->SetCheck(TRUE);
	((CButton *)GetDlgItem(IDC_RADIO3))->SetCheck(TRUE);

	return TRUE;  // 除非将焦点设置到控件，否则返回 TRUE
}

void COpticalFlowMFCDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialogEx::OnSysCommand(nID, lParam);
	}
}

// 如果向对话框添加最小化按钮，则需要下面的代码
//  来绘制该图标。  对于使用文档/视图模型的 MFC 应用程序，
//  这将由框架自动完成。

void COpticalFlowMFCDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // 用于绘制的设备上下文

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// 使图标在工作区矩形中居中
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// 绘制图标
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

//当用户拖动最小化窗口时系统调用此函数取得光标
//显示。
HCURSOR COpticalFlowMFCDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void COpticalFlowMFCDlg::DrawPicToHDC(IplImage *img, UINT ID)
{
	CDC *pDC = GetDlgItem(ID)->GetDC();
	HDC hDC = pDC->GetSafeHdc();
	CRect rect;
	GetDlgItem(ID)->GetClientRect(&rect);
	CvvImage cimg;
	cimg.CopyOf(img); // 复制图片
	cimg.DrawToHDC(hDC, &rect); // 将图片绘制到显示控件的指定区域内
	ReleaseDC(pDC);
}

void COpticalFlowMFCDlg::copyOpticalData(const cv::Mat& flow, cv::Mat& u, cv::Mat& v)
{
	int nRows = flow.rows;
	int nCols = flow.cols;
	if (flow.isContinuous())
	{
		nCols *= nRows;
		nRows = 1;
	}
	int i, j;
	for (i = 0; i < nRows; i++)
	{
		const cv::Point2f* inData = flow.ptr<cv::Point2f>(i);
		float* uPoint = u.ptr<float>(i);
		float* vPoint = v.ptr<float>(i);
		for (j = 0; j < nCols; j++, uPoint++, vPoint++, inData++)
		{
			*uPoint = inData->x;
			*vPoint = inData->y;
		}
	}
}

void COpticalFlowMFCDlg::write2file(float* data, std::ofstream& outfile)
{
	outfile << "+1 ";
	for (int i = 0; i < 76; i++)
		outfile << i + 1 << ":" << *(data + i) << ' ';
	outfile << std::endl;
}

void COpticalFlowMFCDlg::calFeatureTrain(float* matrix, float* featureVector, const float* meanVector, int product)
{
	float* featureMatrix = new float[144];
	for (int i = 0; i < product; i++)
		for (int j = 0; j < 12; j++)
			*(matrix + i * 12 + j) -= *(meanVector + j);

	cblas_sgemm(CblasRowMajor, CblasTrans, CblasNoTrans, 12, 12, product, 1.0, matrix, 12, matrix, 12, 0.0, featureMatrix, 12);

	for (int i = 0; i < 12; i++)
		for (int j = 0; j < 12; j++)
			*(featureMatrix + 12 * i + j) /= (product - 1);

	//mwArray input(12, 12, mxDOUBLE_CLASS, mxREAL);
	//input.SetData(featureMatrix, 144);
	//mwArray output(12, 12, mxDOUBLE_CLASS, mxREAL);
	//mylogm(1, output, input);
	//output.GetData(featureMatrix, 144);

	for (int i = 0; i < 12; i++)
		for (int j = i; j < 12; j++)
			if (!(i == 0 && j == 0 || i == 1 && j == 1))
				*featureVector++ = *(featureMatrix + 12 * i + j);

	delete featureMatrix;
}

void COpticalFlowMFCDlg::calFeature(float* matrix, svm_node* x, const float* meanVector, int product)
{
	int c = 1;
	float* featureMatrix = new float[144];
	for (int i = 0; i < product; i++)
		for (int j = 0; j < 12; j++)
			*(matrix + i * 12 + j) -= *(meanVector + j);

	cblas_sgemm(CblasRowMajor, CblasTrans, CblasNoTrans, 12, 12, product, 1.0, matrix, 12, matrix, 12, 0.0, featureMatrix, 12);

	for (int i = 0; i < 12; i++)
		for (int j = 0; j < 12; j++)
			*(featureMatrix + 12 * i + j) /= (product - 1);

	//mwArray input(12, 12, mxDOUBLE_CLASS, mxREAL);
	//input.SetData(featureMatrix, 144);
	//mwArray output(12, 12, mxDOUBLE_CLASS, mxREAL);
	//mylogm(1, output, input);
	//output.GetData(featureMatrix, 144);

	for (int i = 0; i < 12; i++)
		for (int j = i; j < 12; j++)
			if (!(i == 0 && j == 0 || i == 1 && j == 1))
			{
				x->index = c++;
				x->value = *(featureMatrix + 12 * i + j);
				x++;
			}

	delete featureMatrix;
}

void COpticalFlowMFCDlg::calFeatureFun(cv::Mat& frame, cv::Mat& preframe, std::ofstream& outfile)
{
	int rows = frame.rows;
	int cols = frame.cols;
	int product = rows*cols;

	svm_node* x = new svm_node[77];
	(x + 76)->index = -1;

	cv::Mat flow, flow_u, flow_v;

	cv::Mat kernel_dx = (cv::Mat_<double>(1, 3) << -1, 0, 1);
	cv::Mat kernel_dy = (cv::Mat_<double>(3, 1) << -1, 0, 1);
	cv::Mat kernel_ddx = (cv::Mat_<double>(1, 3) << -1, 2, -1);
	cv::Mat kernel_ddy = (cv::Mat_<double>(3, 1) << -1, 2, -1);

	cv::Mat u_dx, u_ddx, u_dy, u_ddy;
	cv::Mat v_dx, v_ddx, v_dy, v_ddy;

	float* matrix = new float[product * 12];;
	float meanVector[12] = { 0 };
	float featureVector[76];

	double predict_label = 1;

	flow_u.create(rows, cols, CV_32FC1);
	flow_v.create(rows, cols, CV_32FC1);

	if (!preframe.empty())
	{

		calcOpticalFlowFarneback(preframe, frame, flow, 0.5, 3, 15, 3, 5, 1.2, 0);

		copyOpticalData(flow, flow_u, flow_v);

		filter2D(flow_u, u_dx, -1, kernel_dx);
		filter2D(flow_u, u_ddx, -1, kernel_ddx);
		filter2D(flow_u, u_dy, -1, kernel_dy);
		filter2D(flow_u, u_ddy, -1, kernel_ddy);

		filter2D(flow_v, v_dx, -1, kernel_dx);
		filter2D(flow_v, v_ddx, -1, kernel_ddx);
		filter2D(flow_v, v_dy, -1, kernel_dy);
		filter2D(flow_v, v_ddy, -1, kernel_ddy);

		for (int i = 0; i < rows; i++)
		{
			int ti = i * cols * 12;

			const float* uPoint = flow_u.ptr<float>(i);
			const float* vPoint = flow_v.ptr<float>(i);

			const float* udxPoint = u_dx.ptr<float>(i);
			const float* uddxPoint = u_ddx.ptr<float>(i);
			const float* udyPoint = u_dy.ptr<float>(i);
			const float* uddyPoint = u_ddy.ptr<float>(i);

			const float* vdxPoint = v_dx.ptr<float>(i);
			const float* vddxPoint = v_ddx.ptr<float>(i);
			const float* vdyPoint = v_dy.ptr<float>(i);
			const float* vddyPoint = v_ddy.ptr<float>(i);

			for (int j = 0; j < cols; j++)
			{
				int tj = j * 12;
				int tij = ti + tj;
				*(matrix + tij) = (float)(i + 1);
				*(matrix + tij + 1) = (float)(j + 1);

				*(matrix + tij + 2) = *(uPoint + j);
				*(meanVector + 2) += *(uPoint + j);

				*(matrix + tij + 3) = *(vPoint + j);
				*(meanVector + 3) += *(vPoint + j);

				*(matrix + tij + 4) = *(udxPoint + j);
				*(meanVector + 4) += *(udxPoint + j);

				*(matrix + tij + 5) = *(udyPoint + j);
				*(meanVector + 5) += *(udyPoint + j);

				*(matrix + tij + 6) = *(vdxPoint + j);
				*(meanVector + 6) += *(vdxPoint + j);

				*(matrix + tij + 7) = *(vdyPoint + j);
				*(meanVector + 7) += *(vdyPoint + j);

				*(matrix + tij + 8) = *(uddxPoint + j);
				*(meanVector + 8) += *(uddxPoint + j);

				*(matrix + tij + 9) = *(uddyPoint + j);
				*(meanVector + 9) += *(uddyPoint + j);

				*(matrix + tij + 10) = *(vddxPoint + j);
				*(meanVector + 10) += *(vddxPoint + j);

				*(matrix + tij + 11) = *(vddyPoint + j);
				*(meanVector + 11) += *(vddyPoint + j);
			}
		}
		for (int i = 2; i < 12; i++)
			*(meanVector + i) /= product;
		*meanVector = ((float)rows + 1) / 2;
		*(meanVector + 1) = ((float)cols + 1) / 2;

		calFeatureTrain(matrix, featureVector, meanVector, product);
		write2file(featureVector, outfile);
	}

	delete[] x;
	delete[] matrix;
}

bool COpticalFlowMFCDlg::isAbnormal(cv::Mat& frame, cv::Mat& preframe, svm_model* svm_p)
{
	int rows = frame.rows;
	int cols = frame.cols;
	int product = rows*cols;

	svm_node* x = new svm_node[77];
	(x + 76)->index = -1;

	cv::Mat flow, flow_u, flow_v;

	cv::Mat kernel_dx = (cv::Mat_<double>(1, 3) << -1, 0, 1);
	cv::Mat kernel_dy = (cv::Mat_<double>(3, 1) << -1, 0, 1);
	cv::Mat kernel_ddx = (cv::Mat_<double>(1, 3) << -1, 2, -1);
	cv::Mat kernel_ddy = (cv::Mat_<double>(3, 1) << -1, 2, -1);

	cv::Mat u_dx, u_ddx, u_dy, u_ddy;
	cv::Mat v_dx, v_ddx, v_dy, v_ddy;

	float* matrix = new float[product * 12];;
	float meanVector[12] = { 0 };

	double predict_label = 1;

	flow_u.create(rows, cols, CV_32FC1);
	flow_v.create(rows, cols, CV_32FC1);

	if (!preframe.empty())
	{

		calcOpticalFlowFarneback(preframe, frame, flow, 0.5, 3, 15, 3, 5, 1.2, 0);

		copyOpticalData(flow, flow_u, flow_v);

		filter2D(flow_u, u_dx, -1, kernel_dx);
		filter2D(flow_u, u_ddx, -1, kernel_ddx);
		filter2D(flow_u, u_dy, -1, kernel_dy);
		filter2D(flow_u, u_ddy, -1, kernel_ddy);

		filter2D(flow_v, v_dx, -1, kernel_dx);
		filter2D(flow_v, v_ddx, -1, kernel_ddx);
		filter2D(flow_v, v_dy, -1, kernel_dy);
		filter2D(flow_v, v_ddy, -1, kernel_ddy);

		for (int i = 0; i < rows; i++)
		{
			int ti = i * cols * 12;

			const float* uPoint = flow_u.ptr<float>(i);
			const float* vPoint = flow_v.ptr<float>(i);

			const float* udxPoint = u_dx.ptr<float>(i);
			const float* uddxPoint = u_ddx.ptr<float>(i);
			const float* udyPoint = u_dy.ptr<float>(i);
			const float* uddyPoint = u_ddy.ptr<float>(i);

			const float* vdxPoint = v_dx.ptr<float>(i);
			const float* vddxPoint = v_ddx.ptr<float>(i);
			const float* vdyPoint = v_dy.ptr<float>(i);
			const float* vddyPoint = v_ddy.ptr<float>(i);

			for (int j = 0; j < cols; j++)
			{
				int tj = j * 12;
				int tij = ti + tj;
				*(matrix + tij) = (float)(i + 1);
				*(matrix + tij + 1) = (float)(j + 1);

				*(matrix + tij + 2) = *(uPoint + j);
				*(meanVector + 2) += *(uPoint + j);

				*(matrix + tij + 3) = *(vPoint + j);
				*(meanVector + 3) += *(vPoint + j);

				*(matrix + tij + 4) = *(udxPoint + j);
				*(meanVector + 4) += *(udxPoint + j);

				*(matrix + tij + 5) = *(udyPoint + j);
				*(meanVector + 5) += *(udyPoint + j);

				*(matrix + tij + 6) = *(vdxPoint + j);
				*(meanVector + 6) += *(vdxPoint + j);

				*(matrix + tij + 7) = *(vdyPoint + j);
				*(meanVector + 7) += *(vdyPoint + j);

				*(matrix + tij + 8) = *(uddxPoint + j);
				*(meanVector + 8) += *(uddxPoint + j);

				*(matrix + tij + 9) = *(uddyPoint + j);
				*(meanVector + 9) += *(uddyPoint + j);

				*(matrix + tij + 10) = *(vddxPoint + j);
				*(meanVector + 10) += *(vddxPoint + j);

				*(matrix + tij + 11) = *(vddyPoint + j);
				*(meanVector + 11) += *(vddyPoint + j);
			}
		}
		for (int i = 2; i < 12; i++)
			*(meanVector + i) /= product;
		*meanVector = ((float)rows + 1) / 2;
		*(meanVector + 1) = ((float)cols + 1) / 2;

		calFeature(matrix, x, meanVector, product);
		predict_label = svm_predict(svm_p, x);
	}

	delete[] x;
	delete[] matrix;

	if (predict_label == -1)
		return true;
	else
		return false;
}

int COpticalFlowMFCDlg::GetState()
{
	int videoResourceOpt = GetCheckedRadioButton(IDC_RADIO1, IDC_RADIO2);
	int ClassifierOpt = GetCheckedRadioButton(IDC_RADIO3, IDC_RADIO4);

	if (IsDlgButtonChecked(IDC_CHECK) != BST_CHECKED)
	{
		if (videoResourceOpt == IDC_RADIO1)
			if (ClassifierOpt == IDC_RADIO3)
				return 1;
			else
				return 3;
		else
			if (ClassifierOpt == IDC_RADIO3)
				return 2;
			else
				return 4;
	}
	else
	{
		if (videoResourceOpt == IDC_RADIO1)
			if (ClassifierOpt == IDC_RADIO3)
				return 5;
			else
				return 7;
		else
			return 0;
	}
}

void COpticalFlowMFCDlg::OnBnClickedOk()
{
	// TODO:  在此添加控件通知处理程序代码
	//CDC *pDC = GetDlgItem(IDC_SHOW)->GetDC();
	//CWnd *pWnd = GetDlgItem(IDC_SHOW); //GetDlgItem(控件的ID)
	//RECT rect;
	//pWnd->GetClientRect(&rect);

	int flag = GetState();
	if (flag == 0)
	{
		AfxMessageBox(_T("请使用视频文件训练分类器！"));
		return;
	}

	cv::VideoCapture capture;
	if (flag % 2 != 0)
	{
		static TCHAR BASED_CODE szFilter[] = _T("AVI Files (*.avi)|*.avi;*.AVI | RMVB Files (*.rm;*.rmvb)|*.rm;*.RM;*.rmvb;*.RMVB | MKV Files (*.mkv)|*.mkv;*.MKV| \
			MP4 Files (*.mp4)|*.mp4;*.MP4 | WMV Files (*.wmv)|*.wmv;*.WMV | All Files (*.*)|*.*||");
		CFileDialog fileDlg(TRUE, NULL, NULL, 0, szFilter, this);
		if (fileDlg.DoModal() == IDOK)
		{
			CString strFilePath = fileDlg.GetPathName();
			wchar_t *pWChar = strFilePath.GetBuffer();
			strFilePath.ReleaseBuffer();
			int nLen = strFilePath.GetLength(); //获取str的字符数  
			char *videoDst = new char[nLen * 2 + 1];
			memset(videoDst, 0, nLen * 2 + 1);
			wcstombs(videoDst, pWChar, nLen * 2 + 1); //宽字符转换为多字节字符
			capture.open(videoDst);
			delete[] videoDst;
			if (!capture.isOpened())
			{
				AfxMessageBox(_T("无法读取文件！"));
				return;
			}
		}
		else
			return;
	}
	else
	{
		capture.open(0);
		if (!capture.isOpened())
		{
			AfxMessageBox(_T("无法连接至摄像头！"));
			return;
		}
	}

	svm_model* svm_p;
	if (flag == 3 || flag == 4)
	{
		static TCHAR BASED_CODE szFilter[] = _T("Model Files (*.proto)|*.proto;*.PROTO | All Files (*.*)|*.*||");
		CFileDialog fileDlg(TRUE, NULL, NULL, 0, szFilter, this);
		if (fileDlg.DoModal() == IDOK)
		{
			CString strModelPath = fileDlg.GetPathName();
			wchar_t *pWChar = strModelPath.GetBuffer();
			strModelPath.ReleaseBuffer();
			int nLen = strModelPath.GetLength(); //获取str的字符数  
			char *modelDst = new char[nLen * 2 + 1];
			memset(modelDst, 0, nLen * 2 + 1);
			wcstombs(modelDst, pWChar, nLen * 2 + 1); //宽字符转换为多字节字符
			svm_p = svm_load_model(modelDst);
			delete[] modelDst;
			if (!svm_p)
			{
				AfxMessageBox(_T("不是有效的分类器文件！"));
				return;
			}
		}
		else
			return;
	}
	else
	{
		char* modelDst = "model_default.proto";
		svm_p = svm_load_model(modelDst);
		if (!svm_p)
		{
			AfxMessageBox(_T("无法加载默认分类器文件！"));
			return;
		}
	}


	//if (!isInitialize)
	//{
	//	if (!liblogmInitialize())
	//	{
	//		AfxMessageBox(_T("程序无法初始化！"));
	//		return;
	//	}
	//}


	cv::Mat frame, preframe, colorframe;
	CBitmap bitmap1, bitmap2;
	CStatic *statusbox = (CStatic *)GetDlgItem(IDC_SHOW2);

	if (flag <= 4)
	{
		bitmap1.LoadBitmap(IDB_BITMAP1);
		while (true)
		{
			capture >> colorframe;		 //读取当前帧
			if (colorframe.empty())
			{
				AfxMessageBox(_T("播放完毕！"));
				break;
			}

			IplImage ipl_img = colorframe;
			DrawPicToHDC(&ipl_img, IDC_SHOW);
			cvtColor(colorframe, frame, CV_BGR2GRAY);

			if (isAbnormal(frame, preframe, svm_p))
				statusbox->SetBitmap(bitmap1);
			else
				statusbox->SetBitmap(bitmap2);

			frame.copyTo(preframe);
		}
	}
	else
	{
		bitmap1.LoadBitmap(IDB_BITMAP2);
		std::ofstream outfile;

		//static TCHAR BASED_CODE szFilter[] = _T("Model Files (*.proto)|*.proto;*.PROTO | All Files (*.*)|*.*||");
		//CFileDialog fileDlg(TRUE, NULL, NULL, 0, szFilter, this);
		//if (fileDlg.DoModal() == IDOK)
		//{
		//	CString strModelPath = fileDlg.GetPathName();
		//	wchar_t *pWChar = strModelPath.GetBuffer();
		//	strModelPath.ReleaseBuffer();
		//	int nLen = strModelPath.GetLength(); //获取str的字符数  
		//	char *feaName = new char[nLen * 2 + 1];
		//	memset(feaName, 0, nLen * 2 + 1);
		//	wcstombs(feaName, pWChar, nLen * 2 + 1); //宽字符转换为多字节字符
		//	svm_p = svm_load_model(feaName);

		//	delete[] feaName;
		//	if (!svm_p)
		//	{
		//		AfxMessageBox(_T("不是有效的分类器文件！"));
		//		return;
		//	}

		//}
		//else
		//	return;

		char* feaName = "optFea.dat";

		if (flag == 5)
			outfile.open(feaName, std::ios::out);
		else
			outfile.open(feaName, std::ios::app);

		while (true)
		{
			capture >> colorframe;		 //读取当前帧
			if (colorframe.empty())
				break;

			IplImage ipl_img = colorframe;
			DrawPicToHDC(&ipl_img, IDC_SHOW);
			cvtColor(colorframe, frame, CV_BGR2GRAY);

			statusbox->SetBitmap(bitmap1);
			calFeatureFun(frame, preframe, outfile);
			frame.copyTo(preframe);
		}
		outfile.close();

		while (1)
		{
			static TCHAR BASED_CODE szFilter[] = _T("Model Files (*.proto)|*.proto;*.PROTO|");
			CFileDialog fileDlg(FALSE, _T("model"), NULL, 0, szFilter, this);
			if (fileDlg.DoModal() == IDOK)
			{
				CString strModelPath = fileDlg.GetPathName();
				wchar_t *pWChar = strModelPath.GetBuffer();
				strModelPath.ReleaseBuffer();
				int nLen = strModelPath.GetLength(); //获取str的字符数  
				char *modelName = new char[nLen * 2 + 1];
				memset(modelName, 0, nLen * 2 + 1);
				wcstombs(modelName, pWChar, nLen * 2 + 1); //宽字符转换为多字节字符
				svm_p = svm_load_model(modelName);
				char buffer[100] = { 0 };
				sprintf_s(buffer, "libsvmtrain.dll -s 2 -n 0.01 %s %s", feaName, modelName);
				system(buffer);
				delete[] modelName;
				break;
			}
		}

		AfxMessageBox(_T("训练完毕！"));
	}

	CDC *pDC = GetDlgItem(IDC_SHOW)->GetDC();
	CRect rect;
	GetDlgItem(IDC_SHOW)->GetClientRect(&rect);
	CBrush br(GetSysColor(COLOR_BTNFACE));
	pDC->FillRect(rect, &br);
	ReleaseDC(pDC);

	statusbox->SetBitmap(bitmap2);
}

void COpticalFlowMFCDlg::OnBnClickedCancel()
{
	// TODO:  在此添加控件通知处理程序代码
	CDialogEx::OnCancel();
}

void COpticalFlowMFCDlg::OnBnClickedClose()
{
	// TODO:  在此添加控件通知处理程序代码
	CDialogEx::OnCancel();
	CDialogEx::OnClose();
}

void COpticalFlowMFCDlg::OnBnClickedCheck()
{
	// TODO:  在此添加控件通知处理程序代码
	if (IsDlgButtonChecked(IDC_CHECK) == BST_CHECKED)
	{
		int opt = MessageBox(_T("您选择了训练分类器，是否确定？"), _T("确定框"), MB_OKCANCEL);
		if (opt == IDOK)
		{
			((CButton *)GetDlgItem(IDC_CHECK))->SetCheck(TRUE);
			GetDlgItem(IDC_RADIO3)->SetWindowText(_T("从头训练"));
			GetDlgItem(IDC_RADIO4)->SetWindowText(_T("继续训练"));
		}
		else
		{
			((CButton *)GetDlgItem(IDC_CHECK))->SetCheck(FALSE);
			GetDlgItem(IDC_RADIO3)->SetWindowText(_T("默认分类器"));
			GetDlgItem(IDC_RADIO4)->SetWindowText(_T("载入分类器"));
		}
	}
	else
	{
		GetDlgItem(IDC_RADIO3)->SetWindowText(_T("默认分类器"));
		GetDlgItem(IDC_RADIO4)->SetWindowText(_T("载入分类器"));
	}
}