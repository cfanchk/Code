//
// MATLAB Compiler: 5.0 (R2013b)
// Date: Tue Mar 22 16:45:53 2016
// Arguments: "-B" "macro_default" "-W" "cpplib:liblogm" "-T" "link:lib"
// "mylogm.m" 
//

#ifndef __liblogm_h
#define __liblogm_h 1

#if defined(__cplusplus) && !defined(mclmcrrt_h) && defined(__linux__)
#  pragma implementation "mclmcrrt.h"
#endif
#include "mclmcrrt.h"
#include "mclcppclass.h"
#ifdef __cplusplus
extern "C" {
#endif

#if defined(__SUNPRO_CC)
/* Solaris shared libraries use __global, rather than mapfiles
 * to define the API exported from a shared library. __global is
 * only necessary when building the library -- files including
 * this header file to use the library do not need the __global
 * declaration; hence the EXPORTING_<library> logic.
 */

#ifdef EXPORTING_liblogm
#define PUBLIC_liblogm_C_API __global
#else
#define PUBLIC_liblogm_C_API /* No import statement needed. */
#endif

#define LIB_liblogm_C_API PUBLIC_liblogm_C_API

#elif defined(_HPUX_SOURCE)

#ifdef EXPORTING_liblogm
#define PUBLIC_liblogm_C_API __declspec(dllexport)
#else
#define PUBLIC_liblogm_C_API __declspec(dllimport)
#endif

#define LIB_liblogm_C_API PUBLIC_liblogm_C_API


#else

#define LIB_liblogm_C_API

#endif

/* This symbol is defined in shared libraries. Define it here
 * (to nothing) in case this isn't a shared library. 
 */
#ifndef LIB_liblogm_C_API 
#define LIB_liblogm_C_API /* No special import/export declaration */
#endif

extern LIB_liblogm_C_API 
bool MW_CALL_CONV liblogmInitializeWithHandlers(
       mclOutputHandlerFcn error_handler, 
       mclOutputHandlerFcn print_handler);

extern LIB_liblogm_C_API 
bool MW_CALL_CONV liblogmInitialize(void);

extern LIB_liblogm_C_API 
void MW_CALL_CONV liblogmTerminate(void);



extern LIB_liblogm_C_API 
void MW_CALL_CONV liblogmPrintStackTrace(void);

extern LIB_liblogm_C_API 
bool MW_CALL_CONV mlxMylogm(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);


#ifdef __cplusplus
}
#endif

#ifdef __cplusplus

/* On Windows, use __declspec to control the exported API */
#if defined(_MSC_VER) || defined(__BORLANDC__)

#ifdef EXPORTING_liblogm
#define PUBLIC_liblogm_CPP_API __declspec(dllexport)
#else
#define PUBLIC_liblogm_CPP_API __declspec(dllimport)
#endif

#define LIB_liblogm_CPP_API PUBLIC_liblogm_CPP_API

#else

#if !defined(LIB_liblogm_CPP_API)
#if defined(LIB_liblogm_C_API)
#define LIB_liblogm_CPP_API LIB_liblogm_C_API
#else
#define LIB_liblogm_CPP_API /* empty! */ 
#endif
#endif

#endif

extern LIB_liblogm_CPP_API void MW_CALL_CONV mylogm(int nargout, mwArray& o, const mwArray& i);

#endif
#endif
