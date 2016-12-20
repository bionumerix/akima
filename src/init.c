
/*
 * This file contains declarations to interface R with Akimas
 * interpolation packages from ACMs Collected Algorithms Archive.
 *
 * The ACM copyright of the original Fortran code is described at
 *   http://www.acm.org/publications/policies/software-copyright-notice
 *
 * This interface layer is copyright by
 *
 *   Albrecht Gebhardt <albrecht.gebhardt@uni-klu.ac.at>
 *
 * and can be used under both GPL or ACM license to be conform
 * with the restrictions in the above mentioned ACM license.
 *
 */

#include <R.h>
#include <Rinternals.h>

#include "akima.h"

#include <R_ext/Rdynload.h>

/* Fortran interface descriptions: */

/* ACM 526, soon to be removed */
static R_NativePrimitiveArgType idbvip_t[13] = {
  INTSXP,  /* MD,   */
  INTSXP,  /* NCP,  */
  INTSXP,  /* NDP,  */
  REALSXP, /* XD,   */
  REALSXP, /* YD,   */
  REALSXP, /* ZD,   */
  INTSXP,  /* NIP,  */
  REALSXP, /* XI,   */
  REALSXP, /* YI,   */
  REALSXP, /* ZI,   */
  INTSXP,  /* IWK,  */
  REALSXP, /* WK,   */
  LGLSXP   /* MISSI */
};

static R_NativePrimitiveArgType idsfft_t[14] = {
  INTSXP,  /* MD,   */
  INTSXP,  /* NCP,  */
  INTSXP,  /* NDP,  */
  REALSXP, /* XD,   */
  REALSXP, /* YD,   */
  REALSXP, /* ZD,   */
  INTSXP,  /* NXI,  */
  INTSXP,  /* NYI,  */
  REALSXP, /* XI,   */
  REALSXP, /* YI,   */
  REALSXP, /* ZI,   */
  INTSXP,  /* IWK,  */
  REALSXP, /* WK,   */
  LGLSXP   /* MISSI */
};

/* ACM 760: */
static R_NativePrimitiveArgType rgbi3p_t[12] = {
  INTSXP,  /* MD,     */
  INTSXP,  /* NXP,    */
  INTSXP,  /* NYP,    */
  REALSXP, /* XD,     */
  REALSXP, /* YD,     */
  REALSXP, /* ZD,     */
  INTSXP,  /* NIP,    */
  REALSXP, /* XI,     */
  REALSXP, /* YI,     */
  REALSXP, /* ZI,     */
  INTSXP,  /* IER,    */
  REALSXP  /* WK,     */
};

/* ACM 761: */
static R_NativePrimitiveArgType sdbi3p_t[17] = {
  INTSXP,  /* MD,     */
  INTSXP,  /* NDP,    */
  REALSXP, /* XD,     */
  REALSXP, /* YD,     */
  REALSXP, /* ZD,     */
  INTSXP,  /* NIP,    */
  REALSXP, /* XI,     */
  REALSXP, /* YI,     */
  REALSXP, /* ZI,     */
  INTSXP,  /* IER,    */
  REALSXP, /* WK,     */
  INTSXP,  /* IWK,    */
  LGLSXP,  /* EXTRPI, */
  INTSXP,  /* NEAR,   */
  INTSXP,  /* NEXT,   */
  REALSXP, /* DIST    */
  LGLSXP   /* LINEAR  */
};

static R_NativePrimitiveArgType sdsf3p_t[18] = {
  INTSXP,  /* MD,     */
  INTSXP,  /* NDP,    */
  REALSXP, /* XD,     */
  REALSXP, /* YD,     */
  REALSXP, /* ZD,     */
  INTSXP,  /* NXI,    */
  REALSXP, /* XI,     */
  INTSXP,  /* NYI,    */
  REALSXP, /* YI,     */
  REALSXP, /* ZI,     */
  INTSXP,  /* IER,    */
  REALSXP, /* WK,     */
  INTSXP,  /* IWK,    */
  LGLSXP,  /* EXTRPI, */
  INTSXP,  /* NEAR,   */
  INTSXP,  /* NEXT,   */
  REALSXP, /* DIST    */
  LGLSXP   /* LINEAR  */
};

/* ACM 697: */
static R_NativePrimitiveArgType uvip3p_t[8] = {
  INTSXP,  /* NP, */
  INTSXP,  /* ND, */
  REALSXP, /* XD, */
  REALSXP, /* YD, */
  INTSXP,  /* NI, */
  REALSXP, /* XI, */
  REALSXP, /* YI, */
  INTSXP   /* ERR */
};

/* ACM 433: */
static R_NativePrimitiveArgType intrpl_t[7] = {
  INTSXP,  /* L,  */
  REALSXP, /* X,  */
  REALSXP, /* Y,  */
  INTSXP,  /* N,  */
  REALSXP, /* U,  */
  REALSXP, /* V,  */
  INTSXP   /* ERR */
};

/* A. Gebhardt, no ACM code: */
static R_NativePrimitiveArgType biliip_t[9] = {
  REALSXP, /* X0,  */
  REALSXP, /* Y0,  */
  REALSXP, /* Z0,  */
  INTSXP,  /* N0,  */
  REALSXP, /* X,   */
  REALSXP, /* Y,   */
  REALSXP, /* Z,   */
  INTSXP,  /* NX,  */
  INTSXP   /* NY   */
};


static R_FortranMethodDef fortranMethods[] = {
  {"idbvip", (DL_FUNC) &F77_SUB(idbvip), 13, idbvip_t}, /* interpp.old, scheduled for removal */
  {"idsfft", (DL_FUNC) &F77_SUB(idsfft), 14, idsfft_t}, /* interp.old, scheduled for removal  */
  {"sdbi3p", (DL_FUNC) &F77_SUB(sdbi3p), 17, sdbi3p_t}, /* interpp     */
  {"sdsf3p", (DL_FUNC) &F77_SUB(sdsf3p), 18, sdsf3p_t}, /* interp      */
  {"uvip3p", (DL_FUNC) &F77_SUB(uvip3p), 8,  uvip3p_t}, /* aspline     */
  {"intrpl", (DL_FUNC) &F77_SUB(intrpl), 7,  intrpl_t}, /* aspline     */
  {"rgbi3p", (DL_FUNC) &F77_SUB(rgbi3p), 12, rgbi3p_t}, /* bicubic     */
  {"biliip", (DL_FUNC) &F77_SUB(biliip), 9,  biliip_t}, /* bilinear    */
  {NULL, NULL, 0}
};

void
R_init_akima(DllInfo *info)
{
  R_registerRoutines(info,
		     NULL /*cMethods*/, NULL /*callMethods*/,
		     fortranMethods, NULL/*externalMethods*/);
}
