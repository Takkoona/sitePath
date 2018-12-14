// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// getSimilarityMatrix
NumericMatrix getSimilarityMatrix(const ListOf<CharacterVector>& alignedSeqs);
RcppExport SEXP _sitePath_getSimilarityMatrix(SEXP alignedSeqsSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const ListOf<CharacterVector>& >::type alignedSeqs(alignedSeqsSEXP);
    rcpp_result_gen = Rcpp::wrap(getSimilarityMatrix(alignedSeqs));
    return rcpp_result_gen;
END_RCPP
}
// trimTree
SEXP trimTree(const ListOf<IntegerVector>& tipPaths, const ListOf<CharacterVector>& alignedSeqs, NumericMatrix& simMatrixInput, const float similarity, const bool getTips);
RcppExport SEXP _sitePath_trimTree(SEXP tipPathsSEXP, SEXP alignedSeqsSEXP, SEXP simMatrixInputSEXP, SEXP similaritySEXP, SEXP getTipsSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const ListOf<IntegerVector>& >::type tipPaths(tipPathsSEXP);
    Rcpp::traits::input_parameter< const ListOf<CharacterVector>& >::type alignedSeqs(alignedSeqsSEXP);
    Rcpp::traits::input_parameter< NumericMatrix& >::type simMatrixInput(simMatrixInputSEXP);
    Rcpp::traits::input_parameter< const float >::type similarity(similaritySEXP);
    Rcpp::traits::input_parameter< const bool >::type getTips(getTipsSEXP);
    rcpp_result_gen = Rcpp::wrap(trimTree(tipPaths, alignedSeqs, simMatrixInput, similarity, getTips));
    return rcpp_result_gen;
END_RCPP
}
// customTrimTree
SEXP customTrimTree(const ListOf<IntegerVector>& tipPaths, const ListOf<CharacterVector>& alignedSeqs, NumericMatrix& simMatrixInput, const NumericMatrix& treeEdge, const Function& customQualifyFunc, const bool getTips);
RcppExport SEXP _sitePath_customTrimTree(SEXP tipPathsSEXP, SEXP alignedSeqsSEXP, SEXP simMatrixInputSEXP, SEXP treeEdgeSEXP, SEXP customQualifyFuncSEXP, SEXP getTipsSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const ListOf<IntegerVector>& >::type tipPaths(tipPathsSEXP);
    Rcpp::traits::input_parameter< const ListOf<CharacterVector>& >::type alignedSeqs(alignedSeqsSEXP);
    Rcpp::traits::input_parameter< NumericMatrix& >::type simMatrixInput(simMatrixInputSEXP);
    Rcpp::traits::input_parameter< const NumericMatrix& >::type treeEdge(treeEdgeSEXP);
    Rcpp::traits::input_parameter< const Function& >::type customQualifyFunc(customQualifyFuncSEXP);
    Rcpp::traits::input_parameter< const bool >::type getTips(getTipsSEXP);
    rcpp_result_gen = Rcpp::wrap(customTrimTree(tipPaths, alignedSeqs, simMatrixInput, treeEdge, customQualifyFunc, getTips));
    return rcpp_result_gen;
END_RCPP
}
// divergentNode
IntegerVector divergentNode(const ListOf<IntegerVector>& paths);
RcppExport SEXP _sitePath_divergentNode(SEXP pathsSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const ListOf<IntegerVector>& >::type paths(pathsSEXP);
    rcpp_result_gen = Rcpp::wrap(divergentNode(paths));
    return rcpp_result_gen;
END_RCPP
}
// getReference
IntegerVector getReference(const std::string& refSeq, const char gapChar);
RcppExport SEXP _sitePath_getReference(SEXP refSeqSEXP, SEXP gapCharSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const std::string& >::type refSeq(refSeqSEXP);
    Rcpp::traits::input_parameter< const char >::type gapChar(gapCharSEXP);
    rcpp_result_gen = Rcpp::wrap(getReference(refSeq, gapChar));
    return rcpp_result_gen;
END_RCPP
}
// ancestralPaths
ListOf<IntegerVector> ancestralPaths(const ListOf<IntegerVector>& paths, const int minLen);
RcppExport SEXP _sitePath_ancestralPaths(SEXP pathsSEXP, SEXP minLenSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const ListOf<IntegerVector>& >::type paths(pathsSEXP);
    Rcpp::traits::input_parameter< const int >::type minLen(minLenSEXP);
    rcpp_result_gen = Rcpp::wrap(ancestralPaths(paths, minLen));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_sitePath_getSimilarityMatrix", (DL_FUNC) &_sitePath_getSimilarityMatrix, 1},
    {"_sitePath_trimTree", (DL_FUNC) &_sitePath_trimTree, 5},
    {"_sitePath_customTrimTree", (DL_FUNC) &_sitePath_customTrimTree, 6},
    {"_sitePath_divergentNode", (DL_FUNC) &_sitePath_divergentNode, 1},
    {"_sitePath_getReference", (DL_FUNC) &_sitePath_getReference, 2},
    {"_sitePath_ancestralPaths", (DL_FUNC) &_sitePath_ancestralPaths, 2},
    {NULL, NULL, 0}
};

RcppExport void R_init_sitePath(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
