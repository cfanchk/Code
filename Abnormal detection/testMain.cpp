#include "stdafx.h"
#include <iostream>
#include <string>
#include <fstream>
#include "liblogm.h"
#include "mclmcr.h"
#include "matrix.h"
#include "mclcppclass.h"
#include "opencv2\opencv.hpp"
#include "svm.h"
#include "cblas.h"

using namespace std;
using namespace cv;

void copyOpticalData(const Mat& flow, Mat& u, Mat& v)
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
		const Point2f* inData = flow.ptr<Point2f>(i);
		float* uPoint = u.ptr<float>(i);
		float* vPoint = v.ptr<float>(i);
		for (j = 0; j < nCols; j++, uPoint++, vPoint++, inData++)
		{
			*uPoint = inData->x;
			*vPoint = inData->y;
		}
	}
}

void calFeature(float* matrix, svm_node* x, const float* meanVector, int product)
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

	mwArray input(12, 12, mxDOUBLE_CLASS, mxREAL);
	input.SetData(featureMatrix, 144);
	mwArray output(12, 12, mxDOUBLE_CLASS, mxREAL);
	mylogm(1, output, input);
	output.GetData(featureMatrix, 144);

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

int main()
{
	char* videoDst = "D:\\lawn_test_1.avi";
	char* imageDst = "D:\\warning.png";
	char* modelName = "model.proto";

	if (!liblogmInitialize())
	{
		cout << "Could not initialize libmysvd!" << endl;
		system("pause");
	}

	svm_model* svm_p = svm_load_model(modelName);

	svm_node* x = new svm_node[77];
	(x + 76)->index = -1;

	Mat warningImg = imread(imageDst);

	VideoCapture video;
	video.open(videoDst);
	Mat colorframe, frame, preframe, flow;

	Mat flow_u, flow_v;

	Mat kernel_dx = (Mat_<double>(1, 3) << -1, 0, 1);
	Mat kernel_dy = (Mat_<double>(3, 1) << -1, 0, 1);
	Mat kernel_ddx = (Mat_<double>(1, 3) << -1, 2, -1);
	Mat kernel_ddy = (Mat_<double>(3, 1) << -1, 2, -1);

	Mat u_dx, u_ddx, u_dy, u_ddy;
	Mat v_dx, v_ddx, v_dy, v_ddy;

	float* matrix = NULL;
	float meanVector[12] = { 0 };

	int framenum = 0;
	double predict_label;
	while (1)
	{
		video >> colorframe;
		if (colorframe.empty())
			break;

		int rows = colorframe.rows;
		int cols = colorframe.cols;
		int product = rows*cols;
		double t = (double)cvGetTickCount();

		if (matrix == NULL)
			matrix = new float[product * 12];

		flow_u.create(rows, cols, CV_32FC1);
		flow_v.create(rows, cols, CV_32FC1);

		cvtColor(colorframe, frame, CV_BGR2GRAY);
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
			if (predict_label == -1)
			{
				Mat ROI = colorframe(Rect(20, 20, warningImg.cols, warningImg.rows));
				warningImg.copyTo(ROI);
			}
			imshow("Test", colorframe);
		}
		frame.copyTo(preframe);
		waitKey(1);
		framenum++;
		cout << framenum << endl;
		t = ((double)cvGetTickCount() - t) / (cvGetTickFrequency() * 1000);
		cout << "exec time = " << t << "ms\n";
	}

	delete matrix;
	return 0;
}